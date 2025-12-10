#!/bin/bash

# Git sync and build script for Hugo site
# This script runs continuously and pulls changes from git repo

set -e

# Configuration
REPO_DIR="/app/repo"
BUILD_DIR="/usr/share/nginx/html"
GIT_REPO_URL=${GIT_REPO_URL:-"https://github.com/styliteag/blog.git"}
GIT_BRANCH=${GIT_BRANCH:-"main"}
SYNC_INTERVAL=${SYNC_INTERVAL:-300}  # 5 minutes

# SSH Key configuration for private repos
SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:-""}
SSH_KNOWN_HOSTS=${SSH_KNOWN_HOSTS:-""}
USE_SSH=${USE_SSH:-"false"}

# Personal Access Token configuration
GIT_USERNAME=${GIT_USERNAME:-""}
GIT_TOKEN=${GIT_TOKEN:-""}
USE_TOKEN=${USE_TOKEN:-"false"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

# Setup SSH for private repository access
setup_ssh() {
    if [ "$USE_SSH" = "true" ] && [ -n "$SSH_PRIVATE_KEY" ]; then
        log "Setting up SSH for private repository access..."
        
        # Create .ssh directory
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        
        # Write private key (if not already mounted)
        if [ ! -f ~/.ssh/id_rsa ]; then
            echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
            chmod 600 ~/.ssh/id_rsa
        else
            # Key is mounted, just ensure permissions are correct
            chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
        fi
        
        # Write known_hosts if provided
        if [ -n "$SSH_KNOWN_HOSTS" ]; then
            echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
        else
            # Add GitHub to known_hosts
            ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2>/dev/null || true
        fi
        
        # Start ssh-agent and add key
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_rsa
        
        log "SSH setup completed"
    fi
}

# Setup Git credentials for token-based authentication
setup_git_credentials() {
    if [ "$USE_TOKEN" = "true" ] && [ -n "$GIT_USERNAME" ] && [ -n "$GIT_TOKEN" ]; then
        log "Setting up Git credentials for token-based authentication..."
        
        # Configure git to use token authentication
        git config --global credential.helper store
        echo "https://$GIT_USERNAME:$GIT_TOKEN@github.com" > ~/.git-credentials
        chmod 600 ~/.git-credentials
        
        log "Git credentials setup completed"
    fi
}

# Install Hugo if not present
install_hugo() {
    if ! command -v hugo &> /dev/null; then
        log "Installing Hugo..."
        wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.148.0/hugo_extended_0.148.0_Linux-64bit.tar.gz
        cd /tmp && tar -xzf hugo.tar.gz
        mv /tmp/hugo /usr/local/bin/hugo
        chmod +x /usr/local/bin/hugo
        rm /tmp/hugo.tar.gz
        log "Hugo installed successfully"
    fi
}

# Clone or update repository
sync_repo() {
    if [ ! -d "$REPO_DIR/.git" ]; then
        log "Cloning repository from $GIT_REPO_URL..."
        
        # Configure git for SSH if needed
        if [ "$USE_SSH" = "true" ]; then
            git config --global url."git@github.com:".insteadOf "https://github.com/"
        fi
        
        git clone --branch "$GIT_BRANCH" "$GIT_REPO_URL" "$REPO_DIR"
        log "Repository cloned successfully"
        return 0
    else
        cd "$REPO_DIR"
        
        # Check if there are any changes
        git fetch origin "$GIT_BRANCH"
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse "origin/$GIT_BRANCH")
        
        if [ "$LOCAL" != "$REMOTE" ]; then
            log "Changes detected, pulling updates..."
            log "Local: $LOCAL"
            log "Remote: $REMOTE"
            git reset --hard "origin/$GIT_BRANCH"
            log "Repository updated successfully"
            return 0
        else
            log "No changes detected"
            log "Local: $LOCAL"
            log "Remote: $REMOTE"
            return 0
        fi
    fi
}

# Build Hugo site
build_site() {
    log "Building Hugo site..."
    cd "$REPO_DIR"
    
    # Install npm dependencies
    if [ -f "package.json" ]; then
        log "Installing npm dependencies..."
        npm ci --only=production
    fi
    
    # Build the site
    npm run build
    
    # Copy built site to nginx directory
    log "Copying built site to web directory..."
    rm -rf "$BUILD_DIR"/*
    cp -r "$REPO_DIR/public/"* "$BUILD_DIR/"
    
    # Create root index.html redirect for multilingual site
    if [ ! -f "$BUILD_DIR/index.html" ] && [ -f "$BUILD_DIR/en/index.html" ]; then
        log "Creating root index.html redirect to English..."
        cat > "$BUILD_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="0;url=/en/">
    <title>Stylite AG</title>
</head>
<body>
    <p>If you are not redirected automatically, <a href="/en/">click here</a>.</p>
</body>
</html>
EOF
    fi
    
    # Set proper permissions
    chown -R nginx:nginx "$BUILD_DIR"
    
    log "Site built and deployed successfully"
}

# Signal nginx to reload (graceful)
reload_nginx() {
    log "Reloading nginx configuration..."
    nginx -s reload || warn "Failed to reload nginx"
}

# Cleanup function
cleanup() {
    log "Shutting down git sync service..."
    exit 0
}

# Handle signals
trap cleanup SIGTERM SIGINT

# Main loop
main() {
    log "Starting git sync service..."
    log "Repository: $GIT_REPO_URL"
    log "Branch: $GIT_BRANCH"
    log "Sync interval: $SYNC_INTERVAL seconds"
    
    # Setup authentication
    setup_ssh
    setup_git_credentials
    
    # Install Hugo
    install_hugo
    
    # Initial sync and build
    if sync_repo; then
        build_site
        reload_nginx
    else
        # If no changes, still build site initially
        build_site
        reload_nginx
    fi
    
    # Main sync loop
    while true; do
        sleep "$SYNC_INTERVAL"
        
        log "Checking for repository updates..."
        
        if sync_repo; then
            log "Changes detected, rebuilding site..."
            if build_site; then
                reload_nginx
                log "Site updated successfully"
            else
                error "Failed to build site"
            fi
        fi
    done
}

# Check if running as service or one-time sync
if [ "$1" = "once" ]; then
    log "Running one-time sync..."
    setup_ssh
    setup_git_credentials
    install_hugo
    sync_repo
    build_site
    reload_nginx
    log "One-time sync completed"
else
    main
fi