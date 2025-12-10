# Nginx Logging Configuration for Stylite Blog

## Overview

The Stylite blog uses different Nginx logging configurations depending on the deployment environment:

- **Production**: Behind Traefik proxy - logs real client IPs from X-Forwarded-For header
- **Development**: Direct access - logs direct connection IPs

## Production Logging (Behind Traefik)

### Configuration
- File: `docker/nginx.conf`  
- Format: Apache Combined Log with X-Forwarded-For header
- Real IP extraction from trusted proxy networks

### Log Format
```
123.45.67.89 - - [30/Aug/2025:19:30:00 +0000] "GET /blog/ HTTP/1.1" 200 1024 "https://google.com" "Mozilla/5.0"
```

### Trusted Networks
- `172.16.0.0/12` - Docker network range
- `10.0.0.0/8` - Internal networks  
- `192.168.0.0/16` - Private networks

### Docker Compose
```bash
docker-compose up -d  # Production with Traefik logging
```

## Development Logging (Direct Access)

### Configuration
- File: `docker/nginx-dev.conf`
- Format: Apache Combined Log with direct IP
- No proxy IP extraction

### Log Format  
```
127.0.0.1 - - [30/Aug/2025:19:30:00 +0000] "GET /blog/ HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

### Docker Compose
```bash
docker-compose -f docker-compose.dev.yml up -d  # Development logging
```

## Log File Locations

### Production
- **Access Logs**: `/var/log/nginx/access.log` (in web_logs volume)
- **Error Logs**: `/var/log/nginx/error.log` (in web_logs volume)

### Development  
- **Access Logs**: `/var/log/nginx/access.log` (in web_logs_dev volume)
- **Error Logs**: `/var/log/nginx/error.log` (in web_logs_dev volume)
- **Hugo Logs**: `/var/log/nginx/hugo.log` (in web_logs_dev volume)

## Viewing Logs

### Using Log Viewer Script
```bash
# Production logs
./scripts/view-logs.sh docker-prod access -f    # Follow access logs
./scripts/view-logs.sh docker-prod error        # Show error logs

# Development logs  
./scripts/view-logs.sh docker-dev access -f     # Follow access logs
./scripts/view-logs.sh docker-dev hugo -f       # Follow Hugo build logs
```

### Direct Docker Commands
```bash
# Production
docker-compose exec web tail -f /var/log/nginx/access.log
docker-compose exec web tail -f /var/log/nginx/error.log

# Development
docker-compose -f docker-compose.dev.yml exec homepage tail -f /var/log/nginx/access.log
docker-compose -f docker-compose.dev.yml exec homepage tail -f /var/log/nginx/hugo.log
```

## Log Analysis

### Real Client IP Detection
In production behind Traefik, the logs will show:
- **X-Forwarded-For IP**: Real client IP from internet
- **Multiple IPs**: `client, proxy1, proxy2` format for multiple proxies

### Log Parsing
The logs follow Apache Combined Log Format and can be parsed by standard tools:
- **GoAccess**: `goaccess /var/log/nginx/access.log`
- **AWStats**: Standard Apache log format
- **ELK Stack**: Logstash Apache patterns
- **Fail2Ban**: Standard Apache log parsing

## Security Considerations

### Trusted Proxies
Only networks explicitly configured in `set_real_ip_from` are trusted:
- Prevents IP spoofing from untrusted sources
- Ensures accurate client IP logging for security analysis

### Log Rotation
Configure log rotation to prevent disk space issues:
```bash
# Example logrotate configuration
/var/log/nginx/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 nginx nginx
    postrotate
        docker-compose exec web nginx -s reload
    endscript
}
```

## Troubleshooting

### Missing Real IPs
If seeing proxy IPs instead of client IPs:
1. Verify Traefik sends X-Forwarded-For header
2. Check trusted network ranges in nginx.conf
3. Confirm `real_ip_header` directive is correct

### Log Permission Issues
```bash
# Fix log directory permissions
docker-compose exec web chown -R nginx:nginx /var/log/nginx
docker-compose exec web chmod 755 /var/log/nginx
```

### Volume Mount Issues
```bash
# Recreate log volumes
docker-compose down
docker volume rm sty-blog_web_logs
docker-compose up -d
```