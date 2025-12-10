# Adding New Blog Posts

## Quick Method (Recommended)

Use the provided script to quickly create a new blog post:

```bash
./scripts/new-blog-post.sh "Your Blog Post Title"
```

This will:
1. Create a new directory with the current date and slugified title
2. Generate an `index.md` file with proper frontmatter
3. Provide reminders for next steps
4. Include a `slug:` in frontmatter for clean URLs

## Manual Method

### 1. Create Directory
```bash
mkdir content/blog/YYYY-MM-DD-your-post-title/
```

### 2. Create `index.md`
```markdown
---
title: "Your Blog Post Title"
date: 2025-07-09T10:00:00+00:00
slug: "short-seo-slug"
authors: ["Your Name"]
tags: ["tag1", "tag2", "tag3"]
showHero: true
description: "Brief description of your blog post"
---

Your blog post content in Markdown format...
```

### 3. Add Feature Image
Add `feature.png` (1536x1024px recommended) to the same directory.

## Adding Images to Blog Posts

### Featured Image (Hero Image)
- **File**: `feature.png` in the blog post directory
- **Size**: 1536x1024px recommended
- **Usage**: Automatically displayed as hero image when `showHero: true`

### Inline Images

#### Option 1: Images in Post Directory (Recommended)
Store images directly in your blog post directory:

```
content/blog/2025-07-10-my-post/
├── index.md
├── feature.png
├── diagram.png
└── screenshot.jpg
```

**Markdown syntax:**
```markdown
![Alt text](diagram.png "Optional caption")

<!-- Or with more control -->
![Docker Architecture](screenshot.jpg "Docker container architecture overview")
```

#### Option 2: Images in Static Directory
For shared/reusable images, store in `static/images/blog/`:

```markdown
![Alt text](/images/blog/shared-diagram.png "Caption")
```

### Image Best Practices

#### Image Sizes
- **Featured images**: 1536x1024px (hero banner)
- **Inline images**: Max width 800px for best readability
- **Thumbnails**: 300x200px for galleries

#### File Formats
- **Photos**: `.jpg` (smaller file size)
- **Diagrams/Screenshots**: `.png` (better quality)
- **Icons**: `.svg` (scalable)

#### Optimization
- Compress images before adding (use tools like TinyPNG)
- Use descriptive filenames: `zfs-architecture.png` not `image1.png`
- Add meaningful alt text for accessibility

### Advanced Image Usage

#### Images with Captions
```markdown
![ZFS Pool Creation](zfs-pool-setup.png "Creating a ZFS pool with multiple drives")

*Figure 1: ZFS pool configuration showing RAID-Z setup*
```

#### Responsive Images
```markdown
<!-- Hugo will automatically handle responsive images -->
![Network Diagram](network-topology.png "Complete network architecture")
```

#### Image Galleries
```markdown
## Screenshots

![Step 1](setup-step1.png "Initial configuration")
![Step 2](setup-step2.png "Advanced settings")
![Step 3](setup-step3.png "Final result")
```

### Example Blog Post with Images

```markdown
---
title: "Setting up Docker Containers"
date: 2025-07-10T10:00:00+00:00
slug: "short-seo-slug"
authors: ["Your Name"]
tags: ["docker", "containers", "tutorial"]
showHero: true
description: "Complete guide to Docker container setup"
---

Docker containers revolutionize application deployment...

## Architecture Overview

![Docker Architecture](docker-architecture.png "Docker container architecture")

The diagram above shows how Docker containers interact with the host system.

## Step-by-Step Setup

### 1. Install Docker

First, install Docker on your system:

```bash
sudo apt install docker.io
```

### 2. Create Dockerfile

![Dockerfile Example](dockerfile-example.png "Sample Dockerfile configuration")

This screenshot shows a typical Dockerfile structure.

### 3. Build and Run

After building your image:

![Container Running](container-running.png "Docker container in action")

Your container should now be running successfully.

## Troubleshooting

Common issues and solutions:

![Error Messages](common-errors.png "Typical Docker error messages")

If you encounter these errors, try the solutions below...
```

## Important Notes

### Frontmatter Fields
- **title**: The blog post title
- **date**: Publication date in ISO format
- **slug**: Short, descriptive URL slug (3–6 words, lowercase, hyphens)
- **draft**: Set to `true` for drafts, `false` to publish
- **authors**: Array of author names
- **categories**: Post categories
- **tags**: Post tags for better searchability
- **showHero**: Whether to show the hero image
- **description**: SEO description

### Directory Naming Convention
Format: `YYYY-MM-DD-title-with-dashes/`
Example: `2025-07-09-my-new-blog-post/`

### Required Files
1. `index.md` - Main content
2. `feature.png` - Featured image
3. Any inline images (optional)

### Development Workflow
1. Create post with `draft: true`
2. Write and review content
3. Add feature image and inline images
4. Optimize images for web
5. Commit and push to trigger rebuild

## Testing Locally

Start development server:
```bash
docker compose -f docker-compose.dev.yml up
```

Access at: http://localhost:1313 

## Optional: Switch to shorter URLs

To move from dated URLs (e.g., `/blog/2025-08-29-your-post/`) to clean slugs (`/blog/:slug/`):

1) Prepare existing posts (adds `slug` and keeps old URLs via aliases):

```bash
node scripts/add-slugs-and-aliases.js --dry   # preview
node scripts/add-slugs-and-aliases.js        # apply
```

2) Then set in `config/_default/hugo.toml`:

```toml
[permalinks]
  blog = "/blog/:slug/"
```

Important: run the migration first to avoid 404s.
