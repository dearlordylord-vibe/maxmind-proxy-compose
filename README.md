# DISCLAIMER: FULLY VIBE CODED, INCLUDING README

# GeoIP Proxy Service

A standalone GeoIP proxy service using [gabe565/geoip-cache-proxy](https://github.com/gabe565/geoip-cache-proxy).

## Setup

1. Make sure you have Docker and Docker Compose installed
2. (Optional) Modify the port in the `.env` file if needed
3. Run the service:
   ```
   docker-compose up -d
   ```

## Usage

This service acts as a proxy to MaxMind's GeoIP services. It exposes three services:

- `:8080` (configurable via `PORT`, default: 8081) - Updates server (proxies to `updates.maxmind.com`)
- `:8081` (configurable via `DOWNLOAD_PORT`, default: 8082) - Download server (proxies to `download.maxmind.com`) 
- `:6060` (configurable via `DEBUG_PORT`, default: 8083) - Debug and metrics server

### API Calls

You must use the same API format as you would for direct MaxMind API calls, including your license key and account ID:

```
# For updates.maxmind.com endpoints (default port: 8081)
curl "http://localhost:8081/path/to/endpoint?license_key=YOUR_LICENSE_KEY&account_id=YOUR_ACCOUNT_ID"

# For download.maxmind.com endpoints (default port: 8082)
curl "http://localhost:8082/path/to/endpoint?license_key=YOUR_LICENSE_KEY&account_id=YOUR_ACCOUNT_ID"
```

#### Example: Download GeoLite2 Database

```
curl "http://localhost:8082/app/geoip_download?edition_id=GeoLite2-City&license_key=YOUR_LICENSE_KEY&account_id=YOUR_ACCOUNT_ID&suffix=tar.gz" -o GeoLite2-City.tar.gz
```

#### Example: Query IP Information

```
curl "http://localhost:8081/geoip/v2.1/city/8.8.8.8?license_key=YOUR_LICENSE_KEY&account_id=YOUR_ACCOUNT_ID"
```

### Helper Script

A sample helper script `maxmind-query.sh` is included in this repository. You can use it to:

1. Download GeoLite2 database:
   ```
   ./maxmind-query.sh any_ip download
   ```

2. Query IP information:
   ```
   ./maxmind-query.sh 8.8.8.8
   ```

Before using the script, edit it to set your MaxMind license key and account ID.

### Port Configuration

To change the port, either:
1. Edit the `.env` file and change the PORT variable, or
2. Set the PORT environment variable when starting the service:
   ```
   PORT=8081 docker-compose up -d
   ```

## Configuration

The service uses Redis for caching. Additional configuration options can be modified in the `docker-compose.yml` file.

See the [geoip-cache-proxy documentation](https://github.com/gabe565/geoip-cache-proxy) for more configuration options.