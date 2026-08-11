# HangingRabbit's Blog — Design

Date: 2026-08-12

## Purpose

A place to write up learnings from Stanford CS336 (*Language Modeling from Scratch*),
explained vividly enough that writing the post is itself the act of clarifying the
thought. CS336 is the first project folder, not the whole site — more projects will be
added later without restructuring.

Not in scope: recipes, comments, analytics, email signup, tags/tag pages.

## Decisions

| Decision | Choice | Why |
|---|---|---|
| Generator | Quarto | Native LaTeX math and notebook rendering; no Ruby toolchain |
| Repo name | `meghanadhpulivarthi.github.io` | GitHub serves user-named repos at the bare domain — no `/blog-name` in every URL, and a custom domain later is a one-file change |
| Site title | HangingRabbit's Blog | Repo name is plumbing; the title is the identity |
| Hosting | GitHub Pages, `gh-pages` branch | Free, public |
| Publishing | Manual `./publish.sh` | One less moving part than CI; a draft on `main` can never go live by accident |
| Post engine | Static markdown, no execution | Explanation is prose, math, and diagrams — not program output. No Python env for the blog |
| Writing surface | VS Code + Quarto extension, Visual Mode | Closest thing to a WYSIWYG editor; `quarto preview` gives live reload |
| Visual reference | sebastianraschka.com | See below |

## Visual reference

sebastianraschka.com runs Jekyll 4.2.1 with hand-written CSS (no Sass) behind
Cloudflare. There is no public repo to fork, so the CSS is rebuilt from scratch
regardless of generator. Everything adopted below is CSS and templating, not
generator-specific.

Adopted:

- **Year-grouped archive.** Compact vertical list, newest year first. Each row is
  date, category label, linked title, one-to-two-sentence description. No cards, no
  thumbnails, no reading-time estimates.
- **Plain post header.** Title, then a `Aug 12, 2026 by Meghanadh Pulivarthi` byline
  line, then linear prose. Nothing else above the fold.
- **Numbered figure captions** below each figure: `Figure 1. What this shows.`
- **Dark/light toggle** and **RSS**.
- **Short-form is legitimate.** His on-site notes run 400–500 words under a category
  label. A CS336 note does not need to be an essay to be worth publishing.

Deliberately not adopted:

- **The hub homepage.** His has a hero bio and nav to Books, Courses, LLM Gallery, and
  Talks — a decade of accumulation. Cloned behind one post it reads as an empty
  storefront. Homepage stays a short intro plus recent posts until there is something
  real to put in a nav bar.
- **Per-post "Read Next" with thumbnails.** Quarto has no built-in related-posts
  mechanism, and hand-maintaining three links per post rots fast. v1 ends each post
  with a single link back to the archive. Revisit once there are enough posts for
  "related" to mean anything.
- **The Substack tier.** He sends long-form to Substack for email delivery and reach,
  keeping short notes on his own site. That is an audience-building decision, and the
  stated goal here is clarity of thought. Skipped for now; the static site can link
  out to a Substack later without any restructuring.

## Structure

```
meghanadhpulivarthi.github.io/
  _quarto.yml                  # site config, nav, light+dark theme
  index.qmd                    # short intro + 5 most recent posts
  blog.qmd                     # full archive, grouped by year
  about.qmd
  styles.css                   # reading width, typography, archive rows, captions
  ejs/archive.ejs              # custom listing template — year grouping
  publish.sh
  .gitignore                   # _site/, .quarto/
  posts/
    cs336/
      2026-08-12-bpe-tokenizer/
        index.qmd
        images/
  docs/superpowers/specs/      # this file
```

One folder per post so images live next to the text that references them. One folder
per project under `posts/`.

Adding project two later is three steps: create `posts/<project>/`, copy `blog.qmd`
to `<project>.qmd` with its `contents:` glob changed, add one nav entry. The homepage
and the archive both pick up new posts with no changes, since they glob `posts/**`.

## Components

**`_quarto.yml`** — `project: type: website`. Nav is Home, Blog, About, nothing more.
Paired light/dark themes plus `styles.css`, which gives the theme toggle for free.
Native Quarto search enabled. Post-level defaults set here: `toc: true` with
`toc-depth: 2` (CS336 explanations run long, unlike his short notes), and
`author: Meghanadh Pulivarthi` so no post has to repeat it.

**`ejs/archive.ejs`** — the one piece of real templating. Quarto's stock listings do not
group by year, so this template walks the already-sorted items, opens a new `<h2>` when
the year changes, and emits one row per post: date, first category, linked title,
description.

Two non-obvious requirements, both established by probing the rendered output rather than
by reasoning about it. First, `item.date` arrives as a string Quarto has *already*
formatted (`"Aug 12, 2026"`), not as a date-only ISO string — so the template must never
call `new Date()` on it. Re-parsing yields local midnight, and any subsequent UTC
conversion shifts the displayed date back a day. The year is taken from the same string
via `match(/\d{4}/)`, which also guarantees the heading can never disagree with the dates
beneath it. Second, the template body must sit inside a ` ```{=html} ` raw block, or
Pandoc treats the indented HTML as markdown and turns it into code blocks.

**`blog.qmd`** — a listing page, about six lines of front matter: `contents: posts/**`,
`template: ejs/archive.ejs`, `feed: true` for RSS.

**`index.qmd`** — two or three sentences of intro, then a default Quarto listing capped
at five most-recent posts, then a link to the full archive.

**Post front matter** — the contract every post follows:

```yaml
---
title: "What BPE actually merges"
date: 2026-08-12
categories: ["CS336 Note"]
description: "One or two sentences. This is what shows in the archive."
---
```

`description` is required, not optional — the archive is unreadable without it.
`categories` carries the project label that shows on each archive row.

**Figures** — use Quarto's native caption syntax so numbering is automatic and
crossrefs work:

```markdown
![Byte pairs merged in frequency order.](images/merges.png){#fig-merges}
```

Quarto numbers and captions this automatically, but its default delimiter is a colon
(`Figure 1: caption`). Matching the reference site's period requires
`crossref: {title-delim: ". "}` in `_quarto.yml` — with the trailing space, since a bare
`"."` is rewritten as a relative path by Quarto's HTML post-processor.

**`publish.sh`** — `set -euo pipefail`, `cd` to the script's own directory so it runs
from any working directory, echo before each step, then `quarto render` followed by
`quarto publish gh-pages`. No absolute paths.

## First post

`posts/cs336/2026-08-12-bpe-tokenizer/index.qmd`, written in full rather than left as a
placeholder, drawing on the existing `~/Development/assignment1-basics` work. BPE is the
right opener: it is assignment 1, and it is genuinely subtle in ways that reward careful
explanation. It doubles as the reference example for voice, length, and structure —
prose, one worked example, one diagram, code snippets pasted from the assignment repo.

Code snippets are pasted text, not imports. The blog stays decoupled from the CS336
repos; nothing breaks when that code changes.

## Prerequisites

Two installs, neither via `uv` — Quarto is a standalone binary, not a Python package:

- `brew install quarto`
- VS Code Quarto extension (for Visual Mode authoring)

Plus a public GitHub repo named `meghanadhpulivarthi.github.io`, with Pages configured
to serve from the `gh-pages` branch.

## Verification

The site is done when, from a clean clone:

1. `quarto render` completes with no errors and no warnings.
2. `quarto preview` serves a homepage showing the BPE post.
3. `/blog.html` shows the archive with a `2026` year heading above one row reading
   `Aug 12, 2026 · CS336 Note · What BPE actually merges` plus its description.
4. The BPE post renders its byline, a working table of contents, rendered LaTeX, a
   syntax-highlighted code block, and a figure captioned `Figure 1. …`.
5. The dark/light toggle switches both site chrome and post body.
6. `/blog.xml` is a valid feed containing the post. (Quarto names a listing's feed after
   its page, so the archive on `blog.qmd` yields `blog.xml`, not `index.xml`.)
7. `./publish.sh`, run from a different working directory, publishes successfully and
   the post is reachable at `meghanadhpulivarthi.github.io`.
