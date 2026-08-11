# HangingRabbit's Blog

Quarto site published to GitHub Pages at <https://meghanadhpulivarthi.github.io>.

## Writing a post

1. `mkdir -p posts/<project>/YYYY-MM-DD-slug/images`
2. Create `index.qmd` in that folder with front matter — `title`, `date`,
   `categories`, `description` are all required.
3. `quarto preview` for live reload while writing. In VS Code, `⇧⌘F4` toggles Visual Mode.
4. `git commit` when the post is ready.
5. `./publish.sh` to put it live.

Nothing publishes automatically. A draft on `main` stays a draft until you run
`publish.sh`.

## Adding a project section

1. Create `posts/<project>/`.
2. Copy `blog.qmd` to `<project>.qmd`, changing `contents:` to `posts/<project>/**/*.qmd`.
3. Change `title:` in the copy — otherwise the new page renders titled "Blog".
   Leave the copied `date-format: "MMM D, YYYY"` alone: the archive template reads the
   year heading out of that formatted string.
4. Add a navbar entry in `_quarto.yml`.

The homepage and archive glob `posts/**` and pick up new projects with no changes.

## Design docs

- Spec: `docs/superpowers/specs/2026-08-12-blog-design.md`
- Plan: `docs/superpowers/plans/2026-08-12-blog.md`
