# Private Repository Setup

This guide explains how to configure the git sync service to work with private repositories using SSH keys.

## Option 1: SSH Keys (Recommended)

### 1. Generate SSH Key Pair

```bash
# Generate a new SSH key pair
ssh-keygen -t rsa -b 4096 -C "your-email@example.com" -f git_sync_key_rsa

# Generate a new Ed25519 key pair
ssh-keygen -t ed25519     -C "your-email@example.com" -f git_sync_key_ed

# Copy the public key to add to your GitHub repository
cat git_sync_key.pub

# Copy the public key to add to your GitHub repository
cat git_sync_key_ed.pub
```

### 2. Add Public Key to GitHub

1. Go to your GitHub repository
2. Navigate to Settings → Deploy keys
3. Click "Add deploy key"
4. Paste your public key content
5. Give it a title (e.g., "Blog Sync Service")
6. Check "Allow write access" if needed
7. Click "Add key"

### 3. Configure Docker Compose

Update your `docker-compose.yml` file:

```yaml
services:
  gitsync:
    build:
      context: ..
      dockerfile: docker/gitsync.Dockerfile
    environment:
      GIT_REPO_URL: "git@github.com:styliteag/private-blog.git"
      GIT_BRANCH: "main"
      SYNC_INTERVAL: 60
      USE_SSH: "true"
      # You can provide your private key in one of two ways:
      # 1. As a base64-encoded string (recommended for CI/secrets):
      #SSH_PRIVATE_KEY_BASE64: "LS0tLS1CRUdJTiBPUkVOU1NII..."
      # 2. As plain text (YAML block):
      #SSH_PRIVATE_KEY: |
      #  -----BEGIN OPENSSH PRIVATE KEY-----
      #  ...
      #  -----END OPENSSH PRIVATE KEY-----
      # If both are set, SSH_PRIVATE_KEY_BASE64 takes precedence.
    volumes:
      - shared_data:/shared
    restart: unless-stopped
```

### 4. Get Your Private Key Content

```bash
# Display your private key (copy the entire output)
cat ~/.ssh/git_sync_key
```

Replace `YOUR_PRIVATE_KEY_CONTENT_HERE` with the actual private key content.

### How to Base64-Encode Your Private Key

If you want to use SSH_PRIVATE_KEY_BASE64, encode your private key like this:

```bash
base64 -w 0 ~/.ssh/git_sync_key > private_key.b64
```

Then copy the contents of private_key.b64 into SSH_PRIVATE_KEY_BASE64.

## Option 2: Personal Access Token

### 1. Create GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Click "Generate new token (classic)"
3. Give it a name (e.g., "Blog Sync Service")
4. Select scopes: `repo` (for private repos)
5. Click "Generate token"
6. Copy the token immediately

### 2. Configure Docker Compose

```yaml
services:
  gitsync:
    build:
      context: ..
      dockerfile: docker/gitsync.Dockerfile
    environment:
      GIT_REPO_URL: https://github.com/styliteag/private-blog.git
      GIT_BRANCH: main
      SYNC_INTERVAL: 60
      # Token-based authentication
      GIT_USERNAME: your-github-username
      GIT_TOKEN: your-personal-access-token
    volumes:
      - shared_data:/shared
    restart: unless-stopped
```

## Security Notes

- **SSH Keys**: More secure, no expiration, recommended for long-term use
- **Personal Access Tokens**: Simpler setup but require periodic renewal
- Store sensitive data in environment files or secrets management
- Never commit private keys or tokens to version control

## Testing

After configuration, test the setup:

```bash
# Start the services
docker-compose up -d

# Check logs for authentication success
docker-compose logs gitsync
```

You should see "Repository cloned successfully" in the logs if authentication is working. 