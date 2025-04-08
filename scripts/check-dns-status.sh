#!/bin/bash
# Script to check DNS propagation status for GitHub Pages setup

# Configuration - Replace with your domain
DOMAIN="yesiboughtadomainforthis.com"

# GitHub Pages IP addresses
GITHUB_IPS=(
  "185.199.108.153"
  "185.199.109.153"
  "185.199.110.153"
  "185.199.111.153"
)

# GitHub Pages IPv6 addresses
GITHUB_IPV6=(
  "2606:50c0:8000::153"
  "2606:50c0:8001::153"
  "2606:50c0:8002::153"
  "2606:50c0:8003::153"
)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "==== DNS Propagation Check for $DOMAIN ===="

# Check A records
echo -e "\n${YELLOW}Checking A records:${NC}"
A_RECORDS=$(dig +short $DOMAIN A)

if [ -z "$A_RECORDS" ]; then
  echo -e "${RED}❌ No A records found for $DOMAIN${NC}"
else
  MATCH_COUNT=0
  
  for ip in $A_RECORDS; do
    if [[ " ${GITHUB_IPS[*]} " =~ " ${ip} " ]]; then
      echo -e "${GREEN}✅ Found correct GitHub Pages IP: $ip${NC}"
      ((MATCH_COUNT++))
    else
      echo -e "${RED}❌ Found incorrect A record: $ip${NC}"
    fi
  done
  
  if [ $MATCH_COUNT -eq ${#GITHUB_IPS[@]} ]; then
    echo -e "${GREEN}✅ All GitHub Pages A records are correctly configured${NC}"
  else
    echo -e "${YELLOW}⚠️ Only $MATCH_COUNT of ${#GITHUB_IPS[@]} GitHub Pages IPs found${NC}"
  fi
fi

# Check AAAA records (IPv6)
echo -e "\n${YELLOW}Checking AAAA records:${NC}"
AAAA_RECORDS=$(dig +short $DOMAIN AAAA)

if [ -z "$AAAA_RECORDS" ]; then
  echo -e "${YELLOW}⚠️ No AAAA records found (IPv6 not configured)${NC}"
else
  IPV6_MATCH_COUNT=0
  
  for ip in $AAAA_RECORDS; do
    if [[ " ${GITHUB_IPV6[*]} " =~ " ${ip} " ]]; then
      echo -e "${GREEN}✅ Found correct GitHub Pages IPv6: $ip${NC}"
      ((IPV6_MATCH_COUNT++))
    else
      echo -e "${RED}❌ Found incorrect AAAA record: $ip${NC}"
    fi
  done
  
  if [ $IPV6_MATCH_COUNT -eq ${#GITHUB_IPV6[@]} ]; then
    echo -e "${GREEN}✅ All GitHub Pages AAAA records are correctly configured${NC}"
  else
    echo -e "${YELLOW}⚠️ Only $IPV6_MATCH_COUNT of ${#GITHUB_IPV6[@]} GitHub Pages IPv6 addresses found${NC}"
  fi
fi

# Check CNAME for www subdomain
echo -e "\n${YELLOW}Checking www CNAME record:${NC}"
WWW_CNAME=$(dig +short www.$DOMAIN CNAME)

if [ -z "$WWW_CNAME" ]; then
  echo -e "${YELLOW}⚠️ No CNAME record found for www.$DOMAIN${NC}"
else
  if [[ $WWW_CNAME == *"github.io"* ]]; then
    echo -e "${GREEN}✅ www CNAME correctly points to GitHub Pages: $WWW_CNAME${NC}"
  else
    echo -e "${RED}❌ www CNAME points to an incorrect destination: $WWW_CNAME${NC}"
  fi
fi

# Check TXT records for verification
echo -e "\n${YELLOW}Checking TXT records (for verification):${NC}"
TXT_RECORDS=$(dig +short $DOMAIN TXT)

if [ -z "$TXT_RECORDS" ]; then
  echo -e "${YELLOW}⚠️ No TXT records found${NC}"
else
  echo -e "${GREEN}📝 Found TXT records:${NC}"
  echo "$TXT_RECORDS"
fi

# Check if site is accessible
echo -e "\n${YELLOW}Checking if site is reachable:${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN || echo "Failed")

if [ "$HTTP_STATUS" == "200" ]; then
  echo -e "${GREEN}✅ Site is accessible (HTTP 200)${NC}"
elif [ "$HTTP_STATUS" == "301" ] || [ "$HTTP_STATUS" == "302" ]; then
  echo -e "${YELLOW}⚠️ Site is redirecting (HTTP $HTTP_STATUS)${NC}"
else
  echo -e "${RED}❌ Site is not accessible (HTTP $HTTP_STATUS)${NC}"
fi

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. If not all records are present, wait for DNS propagation (up to 48 hours)"
echo "2. Once DNS is confirmed, enable HTTPS in GitHub repository settings"
echo "3. Update your GitHub Pages settings if needed"
echo "4. Check GitHub repository health check status"