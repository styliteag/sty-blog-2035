# Hugo Site Deployment Guide

This Hugo site can be deployed in several ways depending on your needs.

## 🚀 Production Deployment

### Quick Deploy
```bash
# Clone repository on your server
git clone https://github.com/styliteag/blog.git
cd blog

# Build and start
docker compose up -d
```

### Update After Changes
```bash
# Run this script when you push changes to GitHub
./update.sh
```

## 🔄 Auto-Deploy Options

### Option 1: GitHub Actions (Recommended)
- Uses `.github/workflows/deploy.yml`
- Automatically deploys when you push to `main`
- Requires server SSH access in GitHub secrets

### Option 2: Simple Webhook
- Run `./webhook.sh` on your server
- Add webhook URL to GitHub repository settings
- Point to: `http://yourserver.com:9000`

### Option 3: Manual Updates
- SSH to your server
- Run `./update.sh` whenever you want to update

## 🛠️ Development

### Local Development
```bash
# Use development compose file
docker compose -f docker-compose.dev.yml up

# Or run Hugo directly
hugo server --buildDrafts
```

### File Structure
```
├── Dockerfile              # Production build
├── docker-compose.yml      # Production deployment
├── docker-compose.dev.yml  # Development with live reload
├── update.sh              # Manual update script
├── webhook.sh             # Webhook listener
└── .github/workflows/     # GitHub Actions
```

## 📋 Requirements

- Docker & Docker Compose
- Git
- (Optional) GitHub Actions for auto-deploy

## 🌐 Access

After deployment, your site will be available at:
- Production: `http://yourserver.com:82`
- Development: `http://localhost:82`

## 🔧 Configuration

### Environment Variables
```bash
# .env file (optional)
WEBHOOK_PORT=9000
WEBHOOK_SECRET=your-secret-here
```

### Server Setup
1. Install Docker and Docker Compose
2. Clone repository
3. Choose deployment method
4. Run deployment script

That's it! Simple and effective Hugo deployment with Docker.