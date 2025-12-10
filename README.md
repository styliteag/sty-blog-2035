# Stylite AG Homepage

A minimal Hugo-based homepage with dark theme, featuring blog functionality and project showcases.

## Features

- **Hugo Static Site Generator**: Fast, secure, and SEO-friendly
- **Dark Theme**: Professional dark color scheme matching the brand
- **TailwindCSS**: Utility-first CSS framework for rapid development
- **Alpine.js**: Minimal JavaScript framework for interactivity
- **Responsive Design**: Mobile-first approach
- **Blog Support**: Markdown-based content management
- **Project Showcase**: Dedicated section for open source projects

## Content Structure

```
content/
├── blog/           # Blog posts
├── projects/       # Project showcases
└── pages/          # Static pages
```

## Custom Shortcodes

### Video Embed
```markdown
{{< video url="https://youtube.com/embed/example" title="Video Title" thumbnail="/images/thumb.jpg">}}
```

### GitHub Repository
```markdown
{{< github repo="repository-name" user="styliteag" description="Repository description">}}
```

### Image Gallery
```markdown
{{< gallery images="/img1.jpg,/img2.jpg,/img3.jpg" title="Gallery Title">}}
```

### Screenshot
```markdown
{{< screenshot src="/images/screenshot.png" alt="Screenshot" caption="Description" width="full">}}
```

## Development

### Prerequisites
- Hugo Extended (v0.121.0+)
- Node.js (v18+)
- npm

### Setup
1. Install dependencies: `npm install`
2. Start development server: `npm run dev`
3. Build for production: `npm run build`

### CSS Development
TailwindCSS is configured to scan all layout files and generate optimized CSS. The build process will automatically handle CSS optimization.

## Deployment

### Manual
1. Run `npm run build`
2. Deploy the `public/` directory to any static host

## Content Management

### Blog Posts
Create new blog posts in `content/blog/` with frontmatter:

```yaml
---
title: "Post Title"
date: 2024-01-15T10:00:00Z
featured_image: "/images/featured.jpg"
tags: ["tag1", "tag2"]
description: "Post description"
---
```

### Projects
Create project pages in `content/projects/` with frontmatter:

```yaml
---
title: "Project Name"
github_url: "https://github.com/user/repo"
tech_stack: ["Tech1", "Tech2"]
featured_image: "/images/project.jpg"
description: "Project description"
---
```

## Customization

### Theme Colors
Edit `tailwind.config.js` to modify the color scheme:

```javascript
colors: {
  'stylite-red': '#dc2626',
  'stylite-dark': '#111111',
  // ... other colors
}
```

### Navigation
Edit `hugo.toml` to modify the main navigation menu.

## License

This project is licensed under the MIT License.