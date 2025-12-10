#!/bin/bash

# Git sync script for Hugo site
# Continuously monitors GitHub repository and rebuilds site when changes are detected

set -e

# Configuration
REPO_URL=${GIT_REPO_URL:-"https://github.com/styliteag/blog.git"}
REPO_DIR="/app/repo"
BUILD_DIR="/shared/public"
SYNC_INTERVAL=${SYNC_INTERVAL:-60}  # Check every 60 seconds

# SSH Configuration
USE_SSH=${USE_SSH:-"false"}
SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:-""}
SSH_PRIVATE_KEY_BASE64=${SSH_PRIVATE_KEY_BASE64:-""}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
}

info() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')] INFO:${NC} $1"
}

# Setup SSH for private repository access
setup_ssh() {
    if [ "$USE_SSH" = "true" ]; then
        log "🔐 Setting up SSH for private repository access..."
        
        # Create .ssh directory
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        
        # Write private key (if not already mounted)
        if [ ! -f ~/.ssh/id_rsa ]; then
            if [ -n "$SSH_PRIVATE_KEY_BASE64" ]; then
                # Decode base64 key
                echo "$SSH_PRIVATE_KEY_BASE64" | base64 -d > ~/.ssh/id_rsa
                chmod 600 ~/.ssh/id_rsa
                echo "Installed key from SSH_PRIVATE_KEY_BASE64"
            elif [ -n "$SSH_PRIVATE_KEY" ]; then
                # Use plain text key
                echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
                chmod 600 ~/.ssh/id_rsa
                echo "Installed key from SSH_PRIVATE_KEY"
            fi
        else
            # Key is mounted, just ensure permissions are correct
            echo "Key is mounted, just ensure permissions are correct"
            chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
        fi
        echo "Key is installed: $(ls -l ~/.ssh/id_rsa)"
        echo "Key content: $(cat ~/.ssh/id_rsa)"
        
        # Add GitHub to known_hosts
        ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2>/dev/null || true
        
        # Start ssh-agent and add key
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_rsa 2>/dev/null || true
        
        log "✅ SSH setup completed"
    fi
}

# Clone or update repository
sync_repo() {
    if [ ! -d "$REPO_DIR/.git" ]; then
        log "Cloning repository from $REPO_URL..."
        git clone "$REPO_URL" "$REPO_DIR"
        cd "$REPO_DIR"
        #git submodule update --init --recursive
        git status
        git log --oneline -10
        return 0  # New clone = changes detected
    else
        cd "$REPO_DIR"
        
        # Fetch latest changes
        git fetch origin main
        
        # Check if there are any changes
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)
        
        if [ "$LOCAL" != "$REMOTE" ]; then
            log "Changes detected! Pulling updates..."
            log "Local: $LOCAL"
            log "Remote: $REMOTE"
            git status
            git reset --hard origin/main
            git status
            git log --oneline -10
            return 0  # Changes detected
        else
            info "No changes detected returning 1"
            return 1  # No changes
        fi
    fi
}

# Build Hugo site
build_site() {
    log "Building Hugo site..."
    cd "$REPO_DIR"
    
    # Install npm dependencies if needed
    if [ -f "package.json" ]; then
        info "Installing npm dependencies..."
        npm ci --only=production
    fi
    
    # Initialize submodules (for themes)
    git submodule update --init --recursive
    
    # Build the site
    hugo --minify --destination "$BUILD_DIR"
    
    log "✅ Site built successfully!"
}

# Signal main container to update
trigger_update() {
    # Create a trigger file that the main container can watch
    touch /shared/update-trigger
    log "🔄 Triggered site update"
}

# Main loop
main() {
    log "🚀 Starting gitsync service..."
    log "📡 Repository: $REPO_URL"
    log "⏰ Sync interval: ${SYNC_INTERVAL}s"
    
    # Setup SSH if needed
    setup_ssh
    
    # Initial sync and build
    sync_repo
    build_site
    trigger_update
    
    # Main sync loop
    while true; do
        sleep "$SYNC_INTERVAL"
        
        info "🔍 Checking for repository updates..."

        # Only build if there are changes (sync_repo returns 0 if there are changes)
        if sync_repo; then
            log "🔄 Changes detected! Building site..."
            build_site
            trigger_update
        fi
    done
}

# Handle signals for graceful shutdown
cleanup() {
    log "🛑 Shutting down gitsync service..."
    exit 0
}

trap cleanup SIGTERM SIGINT

# Start the service
main