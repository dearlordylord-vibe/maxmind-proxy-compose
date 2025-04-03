#!/bin/bash
# Helper script to query MaxMind GeoIP API through our proxy

# Configuration (edit these values)
LICENSE_KEY="your_license_key"
ACCOUNT_ID="your_account_id"
UPDATES_PORT=8081  # Port for updates.maxmind.com proxy
DOWNLOAD_PORT=8082 # Port for download.maxmind.com proxy

# Default to 8.8.8.8 if no IP is provided
IP_ADDRESS=${1:-8.8.8.8}

# Function to query the /app/geoip_download endpoint for GeoLite2 database
function download_database() {
  EDITION=${1:-"GeoLite2-City"}
  SUFFIX=${2:-"tar.gz"}
  
  echo "Downloading $EDITION database..."
  curl -v "http://localhost:$DOWNLOAD_PORT/app/geoip_download?edition_id=$EDITION&license_key=$LICENSE_KEY&account_id=$ACCOUNT_ID&suffix=$SUFFIX" -o "$EDITION.$SUFFIX"
  
  if [ $? -eq 0 ]; then
    echo "Downloaded $EDITION.$SUFFIX successfully"
  else
    echo "Error downloading database"
  fi
}

# Function to query IP information from the MaxMind web API
function query_ip() {
  echo "Querying information for IP: $IP_ADDRESS"
  curl -v "http://localhost:$UPDATES_PORT/geoip/v2.1/city/$IP_ADDRESS?license_key=$LICENSE_KEY&account_id=$ACCOUNT_ID"
  echo
}

# Show usage information
function show_help() {
  echo "Usage: $0 [IP_ADDRESS] [COMMAND]"
  echo "  IP_ADDRESS: Optional IP address to query (default: 8.8.8.8)"
  echo "  COMMAND: Optional command:"
  echo "    download: Download the GeoLite2 database"
  echo "    help: Show this help message"
  echo ""
  echo "  If no command is provided, the script will query the IP information."
  echo ""
  echo "  Before using, edit this script to set your LICENSE_KEY and ACCOUNT_ID."
}

# Parse command line arguments
COMMAND=${2:-"query"}

case "$COMMAND" in
  download)
    download_database "GeoLite2-City" "tar.gz"
    ;;
  help)
    show_help
    ;;
  query|*)
    query_ip
    ;;
esac