FROM hugomods/hugo:exts AS builder

WORKDIR /src
COPY package.json /src/package.json
COPY package-lock.json /src/package-lock.json
RUN npm ci --only=production
COPY ../. /src/
RUN npm run build


FROM nginx:alpine

# Install inotify-tools for watching file changes
RUN apk add --no-cache inotify-tools bash

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Create watch script
COPY docker/watch-updates.sh /usr/local/bin/watch-updates.sh
RUN chmod +x /usr/local/bin/watch-updates.sh

# Copy the built site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Start both nginx and the watcher
CMD ["sh", "-c", "/usr/local/bin/watch-updates.sh & nginx -g 'daemon off;'"]