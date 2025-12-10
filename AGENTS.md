# Repository Guidelines

## Project Overview
- Hugo static site with Blowfish theme and TailwindCSS.
- Multi-language support (DE default; EN, IT, JA, ZH also supported).
- Blog and project showcase sections; WP content import supported.
- Brand colors: Stylite red `#dc2626`, dark `#111111`.

## Project Structure & Module Organization
- `content/`: Markdown pages and blog posts. Blog posts live in `content/blog/YYYY-MM-DD-slug/` with `index.md` and `feature.png` (1536x1024).
- `layouts/` and `themes/`: Hugo templates (Go templates) and partials. Custom header tweaks live under `layouts/partials/`.
- `assets/css/`: Tailwind source (`input.css`) and built CSS (`output.css`).
- `config/`: Hugo config (`_default/` for prod, `development/` for local overrides).
- `scripts/`: Utilities (`new-blog-post.sh`, `clean-html.js`, `fix-links.js`, `convert-posts.js`).
- `docker/`: Dockerfile, compose files, and Nginx config. Build output goes to `public/` (generated).

## Build, Test, and Development Commands
- Install deps: `npm install`
- Dev server: `npm run dev` (Hugo with drafts) → http://localhost:1313
- Production build: `npm run build` (Hugo `public/` with `--minify`)
- CSS watch (optional): `npm run build-css` (writes `assets/css/output.css`)
- Docker (dev): `docker compose -f docker/docker-compose.dev.yml up`
- New post: `./scripts/new-blog-post.sh "Your Title"`

### Content Management
- Prefer `./scripts/new-blog-post.sh "Your Title"` for blogs (ensures `YYYY-MM-DD-slug/index.md`).
- Projects: `hugo new projects/project-name.md` creates a new project page.

### WordPress Import (optional)
- Import XML: `node scripts/wordpress-import.js path/to/export.xml`.
- Convert posts: `node scripts/convert-posts.js`.
- Clean HTML: `node scripts/clean-html.js`.
- Fix links: `node scripts/fix-links.js`.

## Coding Style & Naming Conventions
- Markdown: use YAML frontmatter as in `BLOG_CREATION.md`/`HOW-TO-BLOG.md`. Directory naming: `YYYY-MM-DD-slug/`; main file `index.md`; hero image `feature.png`.
- Hugo templates: 2-space indentation; prefer partials; avoid inline styles; use Tailwind utility classes.
- JS (scripts): Node 18+, 2-space indentation, semicolons; keep scripts self‑contained in `scripts/`.
- No formatter/linter is enforced; keep changes minimal and consistent with existing files.

## Architecture & Structure

### Theme System
- Base theme: Blowfish (`themes/blowfish/`).
- Tailwind config: `tailwind.config.js` (brand colors, scanning paths).
- Custom layouts: override templates in `layouts/`.

### Content Structure
```
content/
├── blog/           # Blog posts (DE focus)
├── projects/       # Project showcases
└── pages/          # Static pages
```

### Configuration
- Main Hugo config: `config/_default/hugo.toml`.
- Language-specific configs and menus under `config/`.
- Site-wide params in `config/_default/params.toml` (if present).

## Testing Guidelines
- Local verify: `npm run dev`, review pages, menus, translations (DE default), and images.
- Build verify: `npm run build` must succeed; inspect `public/` for broken links/images.
- Content hygiene (optional): `node scripts/clean-html.js` and `node scripts/fix-links.js` when importing legacy HTML; use `convert-posts.js` for WP‑style frontmatter.

## Content Guidelines
- Language: primarily German for blog; ensure translations where applicable.
- Topics: storage solutions, cybersecurity, open‑source, TrueNAS, ZFS.
- Images: blog headers 1536×1024, dark‑theme friendly (see `image-specifications.md`).
- Frontmatter: include categories and tags for organization.

## Commit & Pull Request Guidelines
- Commits: imperative, concise subjects (e.g., "Add Karriere page", "Update baseURL in Hugo configuration"). Group related changes.
- PRs: clear description, linked issue, before/after screenshots of affected pages, and steps to reproduce. Ensure `npm run build` passes. Do not commit `public/` or large binaries.

## Security & Configuration Tips
- Requirements: Hugo Extended v0.121.0+ and Node 18+.
- Config: production `baseURL` in `config/_default/hugo.toml`; for local, prefer `config/development/` overrides.
- Assets: keep images optimized; store post images in the post folder; avoid secrets in content or configs.

## Deployment
- Docker: see `DEPLOYMENT.md` for compose files and workflows (dev and prod).

## Notes
- For writing posts, also see `HOW-TO-BLOG.md` and `BLOG_CREATION.md`.
