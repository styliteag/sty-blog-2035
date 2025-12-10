#!/bin/bash

# Script to create a new blog post for Hugo site
# Usage: ./new-blog-post.sh "My Blog Post Title"

if [ $# -eq 0 ]; then
    echo "Usage: $0 \"Blog Post Title\""
    exit 1
fi

TITLE="$1"
DATE=$(date +%Y-%m-%d)
TIME=$(date -d "4 hours ago" +%Y-%m-%dT%H:%M:%S%z)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-*\|-*$//g')
DIR_NAME="$DATE-$SLUG"
BLOG_DIR="content/blog/$DIR_NAME"

echo "Creating new blog post: $TITLE"
echo "Directory: $BLOG_DIR"

# Create directory
mkdir -p "$BLOG_DIR"

# Create index.md with frontmatter
cat > "$BLOG_DIR/index.md" << EOF
---
title: "$TITLE"
date: $TIME
slug: "$SLUG"
authors: ["Your Name"]
tags: ["tag1", "tag2"]
showHero: true
description: "Brief description of your blog post"
---

Your blog post content goes here...

## Introduction

Write your introduction here. You can add images throughout your content.

## Main Content

### Adding Images

You can add images in two ways:

**Option 1: Images in the same directory (recommended)**
\`\`\`markdown
![Alt text](your-image.png "Caption")
\`\`\`

**Option 2: Images in static directory**
\`\`\`markdown
![Alt text](/images/blog/shared-image.png "Caption")
\`\`\`

### Example with Screenshot

<!-- Add your screenshot here -->
![Example Screenshot](example-screenshot.png "Description of what the screenshot shows")

The image above demonstrates the key concepts discussed.

## Step-by-Step Guide

### Step 1: Setup
First, set up your environment:

\`\`\`bash
# Your commands here
echo "Hello World"
\`\`\`

### Step 2: Configuration
![Configuration Example](config-example.png "Configuration file example")

This screenshot shows the typical configuration setup.

### Step 3: Implementation
Continue with your implementation details...

## Conclusion

Your conclusion here.

### Call to Action
[Contact Us](https://example.com)

## Sources
- Source 1: [Title](https://example.com)
EOF

echo ""
echo "✅ Blog post created successfully!"
echo ""
echo "📁 Directory: $BLOG_DIR"
echo "📝 Content file: $BLOG_DIR/index.md"
echo ""
echo "🖼️  Required images:"
echo "   • feature.png (1536x1024px) - Featured/hero image"
echo "   • Add any inline images referenced in your content"
echo ""
echo "📋 Next steps:"
echo "1. Edit the content: $BLOG_DIR/index.md"
echo "2. Update author name and categories"
echo "3. Add your feature.png image"
echo "4. Add any inline images you reference"
echo "5. Optimize images for web (compress, proper sizes)"
echo "6. Use draft: true to hide posts; omit it to publish"
echo "7. Commit and push to trigger rebuild"
echo ""
echo "💡 Image tips:"
echo "   • Use descriptive filenames (zfs-setup.png not image1.png)"
echo "   • Compress images before adding"
echo "   • Add meaningful alt text for accessibility"
echo "   • Featured images: 1536x1024px"
echo "   • Inline images: max 800px width" 
