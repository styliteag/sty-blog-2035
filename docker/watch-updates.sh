#!/bin/bash

# Watch for update triggers and reload nginx

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "🔍 Starting update watcher..."

# Watch for the trigger file
while true; do
    if [ -f "/shared/update-trigger" ]; then
        log "🔄 Update trigger detected - reloading site..."
        
        # Copy new files to web directory
        if [ -d "/shared/public" ]; then
            rm -rf /usr/share/nginx/html/*
            cp -r /shared/public/* /usr/share/nginx/html/
            ls -ltra /usr/share/nginx/html/
            log "📁 Files updated"
        fi
        
        # Reload nginx
        nginx -s reload
        log "🔄 Nginx reloaded"
        
        # Remove trigger file
        rm -f /shared/update-trigger
        log "✅ Update complete"
    fi
    
    sleep 5
done