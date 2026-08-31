#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Mode selection: personal (default) or company (fail-closed whitelist)
# ============================================================================
SETUP_MODE="personal"
while [ $# -gt 0 ]; do
  case "$1" in
    --company)
      SETUP_MODE="company"
      shift
      ;;
    --help|-h)
      cat <<'HELP'
Usage: setup.sh [--company]

Modes:
  (default)    Personal setup: symlink CLAUDE.md/rules/scripts/hooks/commands,
               all skills, Discord prompt, external repos, MCP template.
  --company    Fail-closed whitelist for corporate deployment:
               link only reviewed skills/rules, skip all interactive
               integrations, block on personal Discord env, verify no
               out-of-list residuals.

Exit codes (company mode):
  0  success
  2  unknown argument
  3  personal Discord env still present (rotate & delete first)
  4  unapproved skill remains in ~/.claude/skills after link phase
  5  managed_unlink / company_link target mismatch (foreign file protected)
  6  ~/.claude/settings.json regen backup failed (fail-closed)
HELP
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

# ============================================================================
# Company mode: whitelist arrays (readonly, 37 skills + 9 rules confirmed
# 2026-08-24 in P02_STEP005). Any addition requires a new SC-3R HEAVY audit.
# ============================================================================
readonly COMPANY_SKILLS=(
  ai-review
  arx-ai-deodorize arx-claim-extract arx-devil-advocate arx-figure-audit
  arx-meta-review arx-rebuttal-update arx-repro-review arx-review-update
  arx-technical-review arx-venue-profile arx-writing-polish
  ast-grep-practice
  blueprint cognitive-rhythm-writing context-budget
  deck-storyline
  japanese-tech-writing
  pr-writing
  presentation-architect
  reimagine retrospective-codify
  safety-guard save-session security-duel self-critique
  setup-order-workflow
  slack-reply-polish slack-report slack-zakki
  task-close task-execute task-init task-redistribute
  translate-programming-language
  verification-loop
  sync-env-pull
  wait-pid
  writing-deodorize
)

# Skills that ONLY belong in company/mirror distribution (never symlinked in
# personal mode). Extensible list — add here when a skill is mirror-only by
# design (e.g. company-facing helpers that would conflict with personal setup).
readonly PERSONAL_SKIP_SKILLS=(
  sync-env-pull
)

readonly COMPANY_RULES=(
  core/00-safety.md core/01-meta.md core/02-workflow.md
  core/03-checklist.md
  coding/common.md coding/python.md coding/shell.md
  destructive-operation-gate.md user-directive-fidelity.md
)

# Informational only. Actual enable uses COMPANY_SKILLS.
readonly COMPANY_SKIP_SKILLS=(
  koebox pdf2md gpu-crossval gpu-deploy arx-source-add
  discord-send review-image
  codex-delegation external-llm-handoff
  sync-env
  gh-private-repo gh-pr-reply pr-review multi-repo-check
  arx-paper-review paper-review-roundflow
  zellij-collab
  skills-review suggest-claude-md-check reorganize
  skill-create empirical-prompt-tuning bp-update voice-review
)

# Portable readlink -f (works on macOS and Linux)
resolve_path() {
    local target="$1"
    if [ -L "${target}" ]; then
        local dir
        dir="$(cd "$(dirname "${target}")" && pwd)"
        target="$(readlink "${target}")"
        # Handle relative symlink targets
        case "${target}" in
            /*) resolve_path "${target}" ;;
            *)  resolve_path "${dir}/${target}" ;;
        esac
    else
        echo "$(cd "$(dirname "${target}")" && pwd)/$(basename "${target}")"
    fi
}

# ============================================================================
# Company mode: helper functions (shellcheck-clean, shell.md compliant)
# ============================================================================

# Return 0 if $1 is in the remaining arguments, 1 otherwise.
contains() {
  local needle="$1"
  shift
  local candidate
  for candidate in "$@"; do
    [[ "${candidate}" == "${needle}" ]] && return 0
  done
  return 1
}

# Structured company-mode log. TAG is a short uppercase category label.
clog() {
  local tag="$1"
  local msg="$2"
  printf '[COMPANY][%s] %s\n' "${tag}" "${msg}"
}

# Remove a symlink only if it points to a path under expected_target.
# Foreign real files or symlinks pointing elsewhere trigger BLOCK exit 5.
# Missing link is a no-op.
managed_unlink() {
  local link_path="$1"
  local expected_target="$2"

  if [ ! -e "${link_path}" ] && [ ! -L "${link_path}" ]; then
    return 0
  fi

  if [ -L "${link_path}" ]; then
    local current expected
    current="$(resolve_path "${link_path}")"
    expected="$(resolve_path "${expected_target}")"
    case "${current}" in
      "${expected}"|"${expected}"/*)
        rm -- "${link_path}"
        clog LINK "unlinked ${link_path}"
        return 0
        ;;
      *)
        clog BLOCK "foreign symlink at ${link_path} -> ${current}"
        exit 5
        ;;
    esac
  fi

  clog BLOCK "not a symlink: ${link_path} (refusing to touch)"
  exit 5
}

# Create symlink src -> dst safely.
# - If dst is a symlink already pointing to src: no-op.
# - If dst is a symlink to elsewhere: BLOCK exit 5.
# - If dst is a real file: BLOCK exit 5.
company_link() {
  local src="$1"
  local dst="$2"

  if [ ! -e "${src}" ]; then
    clog BLOCK "source missing: ${src}"
    exit 5
  fi

  if [ -L "${dst}" ]; then
    local current expected
    current="$(resolve_path "${dst}")"
    expected="$(resolve_path "${src}")"
    if [ "${current}" = "${expected}" ]; then
      return 0
    fi
    clog BLOCK "symlink target mismatch: ${dst} -> ${current} (expected ${expected})"
    exit 5
  fi

  if [ -e "${dst}" ]; then
    clog BLOCK "refusing to overwrite real file: ${dst}"
    exit 5
  fi

  ln -s -- "${src}" "${dst}"
}

# SC-3R R3 H8 mitigation: regenerate ~/.claude/settings.json from company
# template so that Stop/Notification/PreCompact hooks (Discord fire path etc.)
# are wiped. Fail-closed if backup unwritable (Option A + C combo).
regenerate_company_settings_json() {
  local user_settings="${CLAUDE_DIR}/settings.json"
  local template="${REPO_DIR}/templates/settings.json.company.template"

  if [ ! -f "${template}" ]; then
    clog BLOCK "company template missing: ${template}"
    exit 6
  fi

  if [ -e "${user_settings}" ] && [ ! -L "${user_settings}" ]; then
    local backup
    backup="${user_settings}.pre-company-$(date +%Y%m%dT%H%M%S)"
    if ! cp -a -- "${user_settings}" "${backup}"; then
      clog BLOCK "settings.json backup failed: ${backup}"
      exit 6
    fi
    clog INFO "settings.json backed up to ${backup}"
  fi

  # Strip JSONC line comments (// ...) to produce valid JSON.
  local tmp
  tmp="$(mktemp)" || { clog BLOCK "mktemp failed"; exit 6; }
  sed -E 's|([^:])//[^"]*$|\1|; s|^//[^"]*$||' \
    "${template}" | \
    sed 's|{{HOME}}|'"${HOME}"'|g' > "${tmp}"

  if ! python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "${tmp}" \
       >/dev/null 2>&1; then
    clog BLOCK "company template did not produce valid JSON after strip"
    rm -f -- "${tmp}"
    exit 6
  fi

  mv -f -- "${tmp}" "${user_settings}"
  clog LINK "regenerated ${user_settings} (hooks wiped from Personal → Company)"

  # SC-3R follow-up: if a backup exists, alert user that a diff MAY exist
  # (e.g. env vars for AWS/custom models, hooks etc. that were in personal
  # settings). Do NOT print diff contents — may contain secrets.
  if [ -n "${backup:-}" ] && [ -f "${backup}" ]; then
    if ! diff -q "${backup}" "${user_settings}" >/dev/null 2>&1; then
      clog INFO "settings.json differs from backup (possibly ENV vars, model overrides, custom hooks)."
      clog INFO "review manually: diff ${backup} ${user_settings}"
      clog INFO "contents not printed here to avoid leaking secrets."
    fi
  fi
}

# After link phase, ensure every entry under ~/.claude/skills is on whitelist.
verify_no_stray_skills() {
  local skills_dir="${CLAUDE_DIR}/skills"
  local bad=0
  local dst name
  for dst in "${skills_dir}"/*; do
    [ -e "${dst}" ] || continue
    name="$(basename "${dst}")"
    if ! contains "${name}" "${COMPANY_SKILLS[@]}"; then
      clog BLOCK "unapproved skill present: ${name}"
      bad=1
    fi
  done
  (( bad == 0 )) || exit 4
}

# ============================================================================
# Company mode: main flow (dispatched below after CLAUDE_DIR is set)
# ============================================================================
run_company_mode() {
  clog MODE "fail-closed whitelist; interactive integrations disabled"

  # Detach repo-owned directory symlinks from prior personal setup.
  local dir_link
  for dir_link in rules scripts hooks commands; do
    managed_unlink "${CLAUDE_DIR}/${dir_link}" "${REPO_DIR}/${dir_link}"
  done

  # Detach .mcp.json project-scope link if pointing at personal template.
  managed_unlink "${REPO_DIR}/.mcp.json" \
    "${REPO_DIR}/templates/mcp.json.template"

  # Recreate leaf directories.
  mkdir -p "${CLAUDE_DIR}/rules" "${CLAUDE_DIR}/skills"

  # CLAUDE.md link (uses standard personal file — content is generic).
  company_link "${REPO_DIR}/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md"

  # Whitelisted rules.
  local rel src dst
  for rel in "${COMPANY_RULES[@]}"; do
    src="${REPO_DIR}/rules/${rel}"
    dst="${CLAUDE_DIR}/rules/${rel}"
    mkdir -p "$(dirname "${dst}")"
    company_link "${src}" "${dst}"
    clog LINK "rule/${rel}"
  done

  # Skills loop.
  local skill_dir skill_name why linked=0 skipped=0
  for skill_dir in "${REPO_DIR}"/skills/*/; do
    [ -d "${skill_dir}" ] || continue
    skill_name="$(basename "${skill_dir}")"
    dst="${CLAUDE_DIR}/skills/${skill_name}"
    if contains "${skill_name}" "${COMPANY_SKILLS[@]}"; then
      company_link "${skill_dir}" "${dst}"
      clog LINK "skill/${skill_name}"
      linked=$((linked + 1))
    else
      why="not on company allowlist"
      if contains "${skill_name}" "${COMPANY_SKIP_SKILLS[@]}"; then
        why="known personal/external integration"
      fi
      clog SKIP "skill/${skill_name}: ${why}"
      managed_unlink "${dst}" "${skill_dir}"
      skipped=$((skipped + 1))
    fi
  done

  # SC-3R R3 H8 mitigation: regenerate settings.json from company template.
  # This wipes Stop/Notification/PreCompact hooks (Discord fire path etc.).
  regenerate_company_settings_json

  # Discord env guard: BLOCK if personal webhook remnants exist.
  local discord_env="${REPO_DIR}/hooks/discord_notify.env"
  if [ -s "${discord_env}" ]; then
    clog BLOCK "personal Discord env exists: ${discord_env}"
    clog INFO "action: rotate & delete before rerun. Exit 3."
    exit 3
  fi

  # Interactive integrations: always skip in company mode.
  local step
  for step in external-skills external-repos mcp discord order-settings; do
    clog SKIP "step/${step}: disabled in company mode"
  done

  # Verification.
  verify_no_stray_skills

  # Done report.
  clog DONE "linked=${linked} skipped=${skipped} blocked=0 outbound_integrations=0"
  clog INFO "review company artifact excludes .git history before distribution"
  exit 0
}

# Detect repo root from script location
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "=== Claude Code Portable Setup ==="
echo "Repo: ${REPO_DIR}"
echo "Target: ${CLAUDE_DIR}"
echo ""

# Check if ~/.claude/ exists
if [ ! -d "${CLAUDE_DIR}" ]; then
    echo "ERROR: ${CLAUDE_DIR} does not exist. Please run 'claude' at least once first."
    exit 1
fi

# Auto-detect mirror artifact: if personal-only directories are absent,
# force company mode (mirror repo has no hooks/scripts/ so personal mode
# would create dangling symlinks).
if [ ! -d "${REPO_DIR}/hooks" ] && [ ! -d "${REPO_DIR}/scripts" ]; then
    if [ "${SETUP_MODE}" = "personal" ]; then
        echo "INFO: mirror artifact detected (no hooks/scripts/) — using --company mode"
        SETUP_MODE="company"
    fi
fi

# Company mode dispatch. If not company, fall through to personal Step 1..4.
if [ "${SETUP_MODE}" = "company" ]; then
    run_company_mode
fi

# Function to create symlink (backup existing if not already a symlink)
create_symlink() {
    local src="$1"
    local dst="$2"

    if [ -L "${dst}" ]; then
        # Already a symlink - check if it points to the right place
        local current_target
        current_target=$(resolve_path "${dst}")
        local expected_target
        expected_target=$(resolve_path "${src}")
        if [ "${current_target}" = "${expected_target}" ]; then
            echo "  [OK] ${dst} -> already linked"
            return 0
        else
            echo "  [UPDATE] ${dst} -> updating symlink"
            rm "${dst}"
        fi
    elif [ -e "${dst}" ]; then
        # Exists but not a symlink - backup and replace
        echo "  [BACKUP] ${dst} -> ${dst}.pre-setup"
        mv "${dst}" "${dst}.pre-setup"
    fi

    ln -s "${src}" "${dst}"
    echo "  [LINK] ${dst} -> ${src}"
}

echo "--- Step 1: Creating symlinks ---"
create_symlink "${REPO_DIR}/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md"
create_symlink "${REPO_DIR}/rules" "${CLAUDE_DIR}/rules"
create_symlink "${REPO_DIR}/scripts" "${CLAUDE_DIR}/scripts"
create_symlink "${REPO_DIR}/hooks" "${CLAUDE_DIR}/hooks"
create_symlink "${REPO_DIR}/commands" "${CLAUDE_DIR}/commands"

# Agents: NOT auto-linked to ~/.claude/agents/ (to prevent auto-delegation)
# Use via skill or explicit @-mention instead. Reference files in repo: agents/

# Skills: individual symlinks (not directory-level) to allow npx skills to coexist
if [ -L "${CLAUDE_DIR}/skills" ]; then
    echo "  [CONVERT] ${CLAUDE_DIR}/skills: directory symlink -> individual symlinks"
    rm "${CLAUDE_DIR}/skills"
    mkdir -p "${CLAUDE_DIR}/skills"
fi
[ -d "${CLAUDE_DIR}/skills" ] || mkdir -p "${CLAUDE_DIR}/skills"
for skill_dir in "${REPO_DIR}/skills"/*/; do
    [ -d "${skill_dir}" ] || continue
    skill_name=$(basename "${skill_dir}")
    # Skip mirror-only skills in personal mode.
    if contains "${skill_name}" "${PERSONAL_SKIP_SKILLS[@]}"; then
        echo "  [SKIP] ${skill_name} (mirror-only skill)"
        continue
    fi
    create_symlink "${skill_dir}" "${CLAUDE_DIR}/skills/${skill_name}"
done
echo ""

# External skills: install via npx skills if external-skills.txt exists
if [ -f "${REPO_DIR}/external-skills.txt" ]; then
    echo "--- Step 1b: External skills ---"
    # Detect package runner: bunx > npx
    PKG_RUNNER=""
    if command -v bunx >/dev/null 2>&1; then
        PKG_RUNNER="bunx"
    elif command -v npx >/dev/null 2>&1; then
        PKG_RUNNER="npx"
    fi
    if [ -n "${PKG_RUNNER}" ]; then
        echo "  Using: ${PKG_RUNNER}"
        while IFS= read -r line || [ -n "${line}" ]; do
            line="${line%%$'\r'}"
            # Skip comments and empty lines
            [[ -z "${line}" || "${line}" =~ ^[[:space:]]*# || "${line}" =~ ^[[:space:]]*$ ]] && continue
            skill_name=$(echo "${line}" | sed 's/.*@//')
            if [ -d "${CLAUDE_DIR}/skills/${skill_name}" ]; then
                echo "  [OK] ${skill_name} already installed"
            else
                echo "  [INSTALL] ${line}"
                ${PKG_RUNNER} skills add "${line}" -g -y </dev/null 2>&1 || echo "  [WARN] Failed to install ${line}"
            fi
        done < "${REPO_DIR}/external-skills.txt"
    else
        echo "  [SKIP] npx/bunx not found. Install external skills manually:"
        cat "${REPO_DIR}/external-skills.txt"
    fi
    echo ""
fi

# External repos: clone if external-repos.txt exists and repos not yet cloned
if [ -f "${REPO_DIR}/external-repos.txt" ]; then
    echo "--- Step 1c: External reference repos ---"
    bash "${REPO_DIR}/scripts/sync-external-repos.sh" 2>&1 | { grep -vF '[OK]' || true; }
    echo ""
fi

# MCP: symlink .mcp.json to project directories that have .claude/
MCP_TEMPLATE="${REPO_DIR}/templates/mcp.json.template"
if [ -f "${MCP_TEMPLATE}" ]; then
    echo "--- Step 1d: MCP config (.mcp.json) ---"
    # .mcp.json は git リポジトリルートに置く（Claude Code は .git を辿って発見）
    # claude-shared root
    if [ -L "${REPO_DIR}/.mcp.json" ] || [ -f "${REPO_DIR}/.mcp.json" ]; then
        echo "  [OK] ${REPO_DIR}/.mcp.json"
    else
        ln -s templates/mcp.json.template "${REPO_DIR}/.mcp.json"
        echo "  [LINK] ${REPO_DIR}/.mcp.json"
    fi
    echo ""
    echo "  他プロジェクト（別 git リポ）への配置:"
    echo "    ln -s ${REPO_DIR}/templates/mcp.json.template /path/to/project/.mcp.json"
    echo ""
fi

echo "--- Step 2: Discord notification setup ---"
read -p "  Configure Discord notifications? (y/N): " setup_discord
if [ "${setup_discord}" = "y" ] || [ "${setup_discord}" = "Y" ]; then
    echo ""
    echo "  Discord webhook setup:"
    echo "  You need a Discord webhook URL for notifications."
    echo "  (Get one from: Server Settings > Integrations > Webhooks)"
    echo ""

    read -p "  Discord webhook URL (or press Enter to skip): " webhook_url
    if [ -n "${webhook_url}" ]; then
        # Create discord notify env file
        discord_env="${REPO_DIR}/hooks/discord_notify.env"
        cat > "${discord_env}" << ENVEOF
# Discord notification config
# Generated by setup.sh on $(date +%Y-%m-%dT%H:%M:%S%z)
DISCORD_WEBHOOK_DEFAULT="${webhook_url}"
DISCORD_WEBHOOK_CLAUDE="${webhook_url}"
DISCORD_WEBHOOK_JOBS="${webhook_url}"
DISCORD_WEBHOOK_OPS="${webhook_url}"
ENVEOF
        echo "  [WRITE] ${discord_env}"
        echo "  NOTE: Edit ${discord_env} to set different webhooks per channel."

        # Ensure hook script sources the env file
        echo "  Discord hook is at: ${REPO_DIR}/hooks/discord_notify_hook.sh"
    else
        echo "  [SKIP] Discord setup skipped."
    fi
fi
echo ""

echo "--- Step 3: Verify ---"
echo "Checking symlinks:"
for item in CLAUDE.md rules scripts hooks commands; do
    if [ -L "${CLAUDE_DIR}/${item}" ]; then
        target=$(readlink "${CLAUDE_DIR}/${item}")
        echo "  [OK] ${item} -> ${target}"
    elif [ -e "${CLAUDE_DIR}/${item}" ]; then
        echo "  [WARN] ${item} exists but is NOT a symlink"
    else
        echo "  [MISS] ${item} does not exist"
    fi
done
# Skills: check individual symlinks (directory is expected, not a symlink)
if [ -d "${CLAUDE_DIR}/skills" ]; then
    skill_count=$(find "${CLAUDE_DIR}/skills" -maxdepth 1 -type l | wc -l)
    echo "  [OK] skills/ (${skill_count} individual symlinks)"
else
    echo "  [MISS] skills/ directory does not exist"
fi
echo ""

# Order workflow: ensure settings.local.json contains current environment's paths
ORDER_SETTINGS="${REPO_DIR}/order/.claude/settings.local.json"
if [ ! -f "${ORDER_SETTINGS}" ] && [ -d "${REPO_DIR}/order/.claude" ]; then
    echo '{"permissions":{"additionalDirectories":[]}}' > "${ORDER_SETTINGS}"
fi
if [ -f "${ORDER_SETTINGS}" ]; then
    echo "--- Step 3b: Order settings.local.json ---"
    if command -v jq >/dev/null 2>&1; then
        # Add current environment's paths if not already present (don't remove other environments)
        NEEDS_UPDATE=false
        if ! jq -e --arg p "${REPO_DIR}" '.permissions.additionalDirectories | index($p)' "${ORDER_SETTINGS}" >/dev/null 2>&1; then
            NEEDS_UPDATE=true
        fi
        if ! jq -e --arg p "${CLAUDE_DIR}" '.permissions.additionalDirectories | index($p)' "${ORDER_SETTINGS}" >/dev/null 2>&1; then
            NEEDS_UPDATE=true
        fi
        if [ "$NEEDS_UPDATE" = "true" ]; then
            jq --arg cs "${REPO_DIR}" --arg cl "${CLAUDE_DIR}" \
                '.permissions.additionalDirectories = (.permissions.additionalDirectories + [$cs, $cl] | unique)' \
                "${ORDER_SETTINGS}" > "${ORDER_SETTINGS}.tmp" \
                && mv "${ORDER_SETTINGS}.tmp" "${ORDER_SETTINGS}"
            echo "  [OK] additionalDirectories updated for this environment"
        else
            echo "  [OK] additionalDirectories already contains this environment"
        fi
    else
        echo "  [WARN] jq not found. Manually update ${ORDER_SETTINGS}"
    fi
fi
echo ""

echo "--- Step 4: Ensure execute permissions ---"
chmod +x "${REPO_DIR}/scripts/"*.sh 2>/dev/null || true
chmod +x "${REPO_DIR}/hooks/"*.sh 2>/dev/null || true
echo "  [OK] Execute permissions set on scripts and hooks"
echo ""

echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Start a new Claude Code session to verify rules load correctly"
echo "  2. Create an environment branch: git checkout -b pc-$(hostname)"
echo "  3. Push to remote: git remote add origin <url> && git push -u origin main"
