# claude-shared (company distribution)

Fail-closed whitelist subset of `claude-shared` for corporate deployment.

## Setup (WSL2)

```bash
git config --global core.autocrlf input  # WSL line ending
cd ~/box && git clone <this repo url> claude-shared
cd claude-shared
./setup.sh --company
```

Expected output:
```
[COMPANY][DONE] linked=39 skipped=0 blocked=0 outbound_integrations=0
```

## What's included

- **39 skills** (see `skills/`)
- **9 rules** (see `rules/`)
- `setup.sh` with `--company` mode
- `templates/settings.json.company.template`
- `docs/company-deployment.md` (full deployment guide)
- `prompt/` (copy-paste prompt snippets, NOT symlinked — open in editor and paste into Claude Code session)

## What's NOT included (personal-only)

- `hooks/` (Discord integrations)
- `scripts/` (personal helpers)
- `order/`, `reviewing/` (personal project histories)
- Personal templates (`mcp.json.template` etc.)
- Skills excluded via whitelist audit (see `docs/company-deployment.md`)

## License

See `LICENSE` (MIT) and `THIRD_PARTY_NOTICES.md`.
