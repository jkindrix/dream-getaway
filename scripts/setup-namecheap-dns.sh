#!/bin/bash
# Script to configure Namecheap DNS records for GitHub Pages
# This script sets up A records for GitHub Pages and a CNAME record for www subdomain

# Configuration - Replace these with your values
API_USER="YOUR_NAMECHEAP_USERNAME"    # Your Namecheap username
API_KEY="YOUR_API_KEY"                # API key from Namecheap account
USERNAME="YOUR_NAMECHEAP_USERNAME"    # Usually same as API_USER
CLIENT_IP="YOUR_WHITELISTED_IP"       # Your IP address whitelisted in Namecheap
DOMAIN="yesiboughtadomainforthis"     # Your domain name without extension
TLD="com"                             # Domain extension (com, org, net, etc.)
GITHUB_USER="jkindrix"                # Your GitHub username

# API URLs
PRODUCTION_URL="https://api.namecheap.com/xml.response"
SANDBOX_URL="https://api.sandbox.namecheap.com/xml.response"

# Use sandbox for testing, switch to PRODUCTION_URL for actual changes
API_URL="$SANDBOX_URL"

# Function to display usage information
usage() {
  echo "Usage: $0 [--production]"
  echo "  --production  Use production API instead of sandbox"
  exit 1
}

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --production) API_URL="$PRODUCTION_URL"; shift ;;
    --help) usage ;;
    *) echo "Unknown parameter: $1"; usage ;;
  esac
done

echo "==== Namecheap DNS Setup for GitHub Pages ===="
echo "Domain: $DOMAIN.$TLD"
echo "API URL: $API_URL"
echo "Using GitHub Pages IP addresses for A records"

# Get existing hosts to preserve other records
echo "Fetching current DNS records..."
CURRENT_HOSTS=$(curl -s "$API_URL" \
  -d "ApiUser=$API_USER" \
  -d "ApiKey=$API_KEY" \
  -d "UserName=$USERNAME" \
  -d "ClientIp=$CLIENT_IP" \
  -d "Command=namecheap.domains.dns.getHosts" \
  -d "SLD=$DOMAIN" \
  -d "TLD=$TLD")

# Extract error message if present
ERROR_MESSAGE=$(echo "$CURRENT_HOSTS" | grep -oP '(?<=<Error>).*(?=</Error>)')
if [ ! -z "$ERROR_MESSAGE" ]; then
  echo "Error fetching records: $ERROR_MESSAGE"
  exit 1
fi

echo "Setting up GitHub Pages DNS records..."

# Build the API request with GitHub Pages IP addresses
API_REQUEST="ApiUser=$API_USER&ApiKey=$API_KEY&UserName=$USERNAME&ClientIp=$CLIENT_IP&Command=namecheap.domains.dns.setHosts&SLD=$DOMAIN&TLD=$TLD"

# Add A records for GitHub Pages
API_REQUEST="${API_REQUEST}&HostName1=@&RecordType1=A&Address1=185.199.108.153&TTL1=600"
API_REQUEST="${API_REQUEST}&HostName2=@&RecordType2=A&Address2=185.199.109.153&TTL2=600"
API_REQUEST="${API_REQUEST}&HostName3=@&RecordType3=A&Address3=185.199.110.153&TTL3=600"
API_REQUEST="${API_REQUEST}&HostName4=@&RecordType4=A&Address4=185.199.111.153&TTL4=600"

# Add CNAME record for www subdomain
API_REQUEST="${API_REQUEST}&HostName5=www&RecordType5=CNAME&Address5=${GITHUB_USER}.github.io&TTL5=600"

# Add AAAA records for IPv6 support
API_REQUEST="${API_REQUEST}&HostName6=@&RecordType6=AAAA&Address6=2606:50c0:8000::153&TTL6=600"
API_REQUEST="${API_REQUEST}&HostName7=@&RecordType7=AAAA&Address7=2606:50c0:8001::153&TTL7=600"
API_REQUEST="${API_REQUEST}&HostName8=@&RecordType8=AAAA&Address8=2606:50c0:8002::153&TTL8=600"
API_REQUEST="${API_REQUEST}&HostName9=@&RecordType9=AAAA&Address9=2606:50c0:8003::153&TTL9=600"

# Execute the API request
echo "Sending request to Namecheap API..."
RESPONSE=$(curl -s -X POST "$API_URL" -d "$API_REQUEST")

# Check for success
if echo "$RESPONSE" | grep -q "<Status>OK</Status>"; then
  echo "✅ DNS records successfully configured for GitHub Pages!"
  echo "⏱️ DNS changes may take up to 48 hours to propagate."
  echo "📝 Next steps:"
  echo "  1. Wait for DNS propagation"
  echo "  2. Verify domain ownership in GitHub repository settings"
  echo "  3. Enable HTTPS in GitHub Pages settings once the certificate is provisioned"
else
  ERROR_MESSAGE=$(echo "$RESPONSE" | grep -oP '(?<=<Error>).*(?=</Error>)' || echo "Unknown error")
  echo "❌ Failed to configure DNS records: $ERROR_MESSAGE"
  echo "See the full response for details:"
  echo "$RESPONSE"
fi

echo ""
echo "To verify DNS propagation, use 'dig $DOMAIN.$TLD +noall +answer'"