FROM hugomods/hugo:exts

# Install git, SSH, and required tools
RUN apk add --no-cache git bash curl openssh-client

# Set working directory
WORKDIR /app

# Install hugo
#RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.148.0/hugo_extended_0.148.0_Linux-64bit.tar.gz | tar -xz -C /usr/local/bin/ hugo
#RUN chmod +x /usr/local/bin/hugo

# Create sync script
COPY docker/gitsync.sh /app/gitsync.sh
RUN chmod +x /app/gitsync.sh

#RUN mkdir -p /app/repo
## Prefill /app/repo with the current directory
#COPY ../package.json /app/repo/package.json
#COPY ../package-lock.json /app/repo/package-lock.json
#
#RUN cd /app/repo && npm ci --only=production
#
#COPY .. /app/repo/
#
#RUN cd /app/repo && npm run build

# Default command
CMD ["/app/gitsync.sh"]