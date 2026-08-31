# anti-patterns.md

Patterns that reliably produce AI-generated-looking decks. Each entry
names the pattern, explains why it happens (usually a lazy default,
sometimes a specific AI cognitive bias), gives a test for detecting
it in a draft, and states what to do instead.

Use this file at review time and — more importantly — before drafting
a slide, so the default doesn't slip in unnoticed.

---

## 1. The 3-column card grid because there happen to be three bullets

Why it happens:
  The evidence enumerated three items, and card grids are the easiest
  layout to produce that "fills the slide". AI models default to it
  hard, because it always looks structurally plausible even when the
  underlying relationship is nothing like three parallel peers.

Detect by asking:
  Are these three items actually peers on the same axis, or are they
  a sequence, a causal chain, or nested under a common parent? Would
  removing the labels still leave the relationship visible?

Do instead:
  Route the relationship through [visual-grammar.md](visual-grammar.md).
  Three sequential steps become a horizontal process. Three items
  under a parent become a tree. Three items scored on two axes become
  a 2×2. Only three genuinely independent, equal-weight peers earn a
  three-card layout — and even then, only if the message is
  "these three coexist", not "one of these is the recommendation".

---

## 2. Generic icons that add no information

Why it happens:
  Icons feel like they "make the slide look designed". A gear next to
  "Process", a lightbulb next to "Idea", a check next to "Result".
  They fill space but encode nothing the label doesn't already say.

Detect by asking:
  If I removed this icon, would the reader lose any information?
  Would the icon-less slide be less understandable, or only less
  decorated?

Do instead:
  Remove any icon that does not encode a distinction the reader has
  to make. Reserve icons for cases where the icon carries meaning:
  denoting artifact type (document / spreadsheet / deck), denoting
  actor (person / organization / system), denoting a decision
  (diamond) versus a process (rectangle). If in doubt, leave it out.

---

## 3. Decorative accent lines under titles

Why it happens:
  Templates ship with a colored underline beneath the title as a
  wayfinding cue for a specific brand system. AI-generated decks
  inherit the underline but not the system it belonged to, so it
  becomes pure ornament. Anthropic's PPTX skill explicitly flags
  title-underline accents as a "characteristic of AI-generated slides".

Detect by asking:
  Does the line under the title distinguish this slide from other
  slides, mark a section boundary, or encode status? If it does the
  same thing on every slide, it is not wayfinding — it is decoration.

Do instead:
  Remove the underline. Use whitespace and typographic weight to
  separate the title from the body. If section wayfinding is genuinely
  needed, use a small semantic marker (section label, progress dots)
  rather than a per-slide decorative stripe.

---

## 4. Decorative color bars framing the slide

Why it happens:
  Sidebar strips, top-and-bottom color rails, and framing rectangles
  come from magazine-layout templates where they carried a visual
  identity function. Reused blindly, they eat body area and add no
  information.

Detect by asking:
  Would removing the color bar change what the reader learns? Does
  the bar encode a state (phase, section, status) or is it uniform
  across all slides?

Do instead:
  Cut framing bars. Reclaim the body area for the message. Use
  restrained wayfinding (section header, page number) only where a
  reader would actually get lost.

---

## 5. Gradient backgrounds and gradient shape fills

Why it happens:
  Gradients read as "modern" and are a cheap way to make a flat slide
  feel designed. AI models pick them up as a stylistic default,
  independent of whether the gradient encodes anything.

Detect by asking:
  Does the gradient encode a quantitative dimension (heat map, scale)
  or a semantic transition (before → after)? If it is uniform across
  the deck or applied to a single shape for "polish", it is decoration.

Do instead:
  Use flat fills. Reserve gradients for cases where the transition of
  color genuinely encodes a variable (temperature, magnitude, time
  progression). A slide is not more informative for being glossier.

---

## 6. All regions of the slide at equal visual weight

Why it happens:
  When the composition step is skipped, elements default to roughly
  equal size. The result: no focal point. Every element competes for
  attention; none wins.

Detect by asking:
  Squint at the slide. Which element is loudest? If more than one
  element ties for "loudest", the slide has no focal point.

Do instead:
  Enforce a primary/secondary weight split (see
  [slide-composition.md](slide-composition.md)). The message-carrying
  element takes 60–80% of the body; supporting material takes the
  rest. If the message doesn't have a clear priority element, the
  message itself may not be ready — back up to the message step.

---

## 7. Charts inserted because "there is data" rather than because a quantitative relationship must be shown

Why it happens:
  Data availability triggers "make a chart" as a reflex, independent
  of whether the chart adds understanding.

Detect by asking:
  What quantitative relationship does this chart uniquely reveal that
  a sentence or a table would not? If the answer is "none", the
  chart is decorative.

Do instead:
  Replace a decorative chart with the actual message — a hero metric,
  a one-line stated conclusion, or a compact table. Add the chart
  back only if a specific quantitative relationship (trend, share,
  distribution, comparison) is genuinely the point.

---

## 8. Topic titles instead of action titles

Why it happens:
  Topic titles ("Challenges", "Results", "Approach", "課題", "結果",
  "アプローチ") are safe and factual — they don't commit to a claim,
  so they can't be wrong. AI models default to them because they are
  the training-data average.

Detect by asking:
  Does this headline commit to a specific claim? Could I paste this
  headline into an unrelated deck and it would still be "correct"?
  If yes, it's a topic title, not an action title.

Do instead:
  Rewrite headlines to state the conclusion. "Challenges" becomes
  "Three challenges block the Q1 launch; the first is decisive."
  "Approach" becomes "We recommend a phased rollout starting with
  segment X." See [storyline.md](storyline.md) on the headline spine.

---

## 9. Variety-for-variety layout changes across slides

Why it happens:
  The instinct that "each slide should look different" for visual
  interest, or the AI habit of picking a fresh template per slide
  because reusing feels lazy. But when the semantic structure
  repeats, using the same layout is a strength: readers learn the
  layout once and read subsequent slides faster.

Detect by asking:
  Are two adjacent slides doing the same job (both are comparisons,
  or both are process flows) with different layouts? If yes, the
  variety is fighting the reader.

Do instead:
  Reuse a layout whenever the semantic structure genuinely repeats.
  Change layout only when the underlying relationship changes.
  Consistency serves the reader more than variety.

---

## 10. Copying a layout because "it looked nice" (form-first)

Why it happens:
  The reverse of the routing table: start with an appealing layout,
  then push content into it. The result: content shape and layout
  shape don't match, and the reader is left decoding.

Detect by asking:
  Did I choose this layout from the message (via
  [visual-grammar.md](visual-grammar.md)), or did I pick the layout
  first and then fit the message to it?

Do instead:
  Always route from message → relationship → visual form → layout.
  A pretty layout that doesn't match the relationship is worse than
  a plain layout that does.

---

## 11. Text-only slides where a diagram would speed comprehension

Why it happens:
  When the composition step is skipped, prose is the fallback. It's
  faster to write than to design. But when the message is about a
  structure — a process, a comparison, a hierarchy — prose forces
  the reader to reconstruct the structure from words.

Detect by asking:
  Does the message describe a structural relationship (process,
  comparison, hierarchy, mechanism)? If yes, is a diagram carrying
  it, or am I asking the reader to build the diagram in their head?

Do instead:
  If the message is structural, use the diagram form from
  [visual-grammar.md](visual-grammar.md). Prose is the right form
  when the message is genuinely narrative and non-structural.

---

## 12. Overloading a slide because "the mode is leave-behind"

Why it happens:
  Leave-behind mode legitimately permits higher information density,
  so this becomes an excuse to skip hierarchy discipline. The result
  is a slide with lots of information and no path through it.

Detect by asking:
  Even in leave-behind mode, is there a focal point and a reading
  order? Or is the slide a wall of equal-weight boxes?

Do instead:
  Density is not the enemy; unstructured density is. In leave-behind
  mode, keep the primary/secondary weight split, keep one emphasis
  per slide, and use typography (headings, subheadings, whitespace
  between blocks) to give the reader a path. Density plus hierarchy
  reads fine; density without hierarchy does not.

---

## 13. Two concepts sharing the same encoding channel

Why it happens:
  A slide gets built in isolation. Grey means "our team" on the slide
  the author was working on; grey later means "online meeting" on a
  different slide, because the author picked a plausible color for
  each slide separately.

Detect by asking:
  For each concept category (who / what / where / when / how /
  importance), what visual channel does the deck use? Does any
  channel encode two different concepts?

Do instead:
  Pick one channel per concept for the whole deck and enforce it.
  See the encoding table in [visual-grammar.md](visual-grammar.md).
  At review time, run a color/shape/position audit across the deck.

---

## 14. Font-shrinking to make content fit

Why it happens:
  When a slide is crowded, the fast fix is to shrink the type. This
  hides the real problem: the slide has too much content or the
  wrong content.

Detect by asking:
  Is body text below the deck's stated floor? Is there content on
  this slide that would fit at the intended size if something were
  cut?

Do instead:
  Run the composition triage in
  [slide-composition.md](slide-composition.md) before shrinking type:
  is the message one message or two? Does every element earn its
  place? Is decoration consuming real estate? Is a sub-argument on
  the wrong slide? Font-shrinking is last resort, not first.

---

## 15. Stock-photo hero as filler

Why it happens:
  A "smiling business people shaking hands" hero image, a laptop-on-
  desk photograph, a stock skyline. AI-generated decks and template
  defaults reach for these when a slide feels empty. The image adds
  atmosphere but zero information — and the atmosphere is generic
  enough that the reader registers "AI slide".

Detect by asking:
  Does this photograph encode data, show a mechanism, or identify a
  specific person / place / artifact? Or is it there because the
  slide "needed a visual" and the photograph is the least specific
  visual the model could produce?

Do instead:
  Remove the stock photograph. Replace with a data visual, a diagram
  of the mechanism, or (often best) whitespace plus a stronger
  headline. Keep photographs only when they carry information the
  reader needs — a screenshot of the product, a photo of the specific
  hardware being discussed, a chart image reproduced from a source.

---

## 16. Generic AI clip-art or cartoon illustration

Why it happens:
  Cartoon-style illustrations (soft-outline characters, "3D isometric"
  workflow scenes, playful marketing spot-art) are a default output of
  image-generation tools. They fill blank areas and look "modern"
  without demanding a decision from the author.

Detect by asking:
  Is the illustration doing any semantic work — showing a mechanism,
  identifying an artifact, differentiating an actor — or is it wrapping
  a generic label in visual polish?

Do instead:
  Cut the illustration. If a visual is genuinely needed, use a
  diagram from [visual-grammar.md](visual-grammar.md), a chart of the
  data, or a schematic showing the actual thing under discussion.
  Ornamental illustration is one of the strongest "AI-generated" tells.

---

## 17. Redundant per-slide footer branding

Why it happens:
  Templates carry a logo, date, deck title, and page number stamp on
  every slide. In-house presentations to a familiar audience rarely
  need this; the branding is inertia, not communication, and it eats
  body area on every slide.

Detect by asking:
  Does the reader need the logo / date / deck title on this slide to
  understand it? Would they be confused about the source if the footer
  were absent? If the deck circulates internally and the audience
  already knows who made it, the answer is usually no.

Do instead:
  Strip per-slide footer branding by default. Keep it only where the
  deck will circulate externally, be excerpted, or be printed and lose
  its cover context. Page numbers may still earn their place; the
  logo-and-date banner usually does not.

---

## 18. Emoji in the headline

Why it happens:
  A rocket, a lightbulb, a check mark, a fire emoji dropped into a
  slide title reads as "engaging" in chat-culture defaults. AI models
  trained on informal text carry the habit into slides where the tone
  is meant to be crisp and evidentiary.

Detect by asking:
  Does the emoji encode a distinction the reader has to make (status
  flag in a table row, priority marker in a list), or is it decorative
  punctuation attached to the headline?

Do instead:
  Remove emoji from headlines. Use text. Reserve emoji or icon glyphs
  for cases where the glyph carries meaning inside a compact visual
  (a legend, a table status column) and the deck's tone accepts them.
  In an executive or evidentiary deck, remove them everywhere.

---

## Review workflow

Run this file at two points:

1. **Before drafting a slide:** scan the list; make sure the layout
   choice isn't a defaulted anti-pattern.
2. **At deck review:** walk the deck and flag each slide against
   each anti-pattern; combine with the tests in
   [review-rubric.md](review-rubric.md).

See also: [SKILL.md](../SKILL.md), [visual-grammar.md](visual-grammar.md),
[slide-composition.md](slide-composition.md),
[review-rubric.md](review-rubric.md).
