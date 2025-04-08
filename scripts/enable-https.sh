#!/bin/bash
# Script to enable HTTPS enforcement on GitHub Pages once DNS is configured

# Configuration - Replace with your values
GITHUB_REPO_OWNER="jkindrix"
GITHUB_REPO_NAME="yesiboughtadomainforthis"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "==== GitHub Pages HTTPS Enforcement Script ===="
echo "Repository: $GITHUB_REPO_OWNER/$GITHUB_REPO_NAME"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ You are not authenticated with GitHub CLI${NC}"
    echo "Please run 'gh auth login' first"
    exit 1
fi

# Check current GitHub Pages status
echo -e "\n${YELLOW}Checking current GitHub Pages status...${NC}"
PAGES_STATUS=$(gh api /repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/pages)

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to retrieve GitHub Pages status${NC}"
    exit 1
fi

# Extract relevant information
CURRENT_DOMAIN=$(echo "$PAGES_STATUS" | grep -o '"cname":"[^"]*"' | cut -d'"' -f4)
CURRENT_HTTPS=$(echo "$PAGES_STATUS" | grep -o '"https_enforced":[a-z]*' | cut -d':' -f2)
CURRENT_STATUS=$(echo "$PAGES_STATUS" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

echo -e "Current status: ${YELLOW}$CURRENT_STATUS${NC}"
echo -e "Custom domain: ${YELLOW}$CURRENT_DOMAIN${NC}"
echo -e "HTTPS enforced: ${YELLOW}$CURRENT_HTTPS${NC}"

# Check if HTTPS is already enforced
if [[ "$CURRENT_HTTPS" == "true" ]]; then
    echo -e "\n${GREEN}✅ HTTPS is already enforced for this site${NC}"
    exit 0
fi

# Check health status for certificate
echo -e "\n${YELLOW}Checking certificate status...${NC}"
HEALTH_STATUS=$(gh api /repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/pages/health)

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to retrieve health status${NC}"
else
    # Output may be empty if no issues
    if [[ -z "$HEALTH_STATUS" || "$HEALTH_STATUS" == "{}" ]]; then
        echo -e "${GREEN}✅ No health issues detected${NC}"
    else
        echo -e "${YELLOW}⚠️ Health check returned:${NC}"
        echo "$HEALTH_STATUS"
    fi
fi

# Try to enable HTTPS
echo -e "\n${YELLOW}Attempting to enable HTTPS...${NC}"
ENABLE_RESULT=$(echo '{"https_enforced": true}' | gh api --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  /repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/pages --input - 2>&1)

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ Successfully enabled HTTPS enforcement!${NC}"
    echo -e "\n${YELLOW}Updated GitHub Pages status:${NC}"
    gh api /repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/pages
else
    if [[ "$ENABLE_RESULT" == *"certificate does not exist"* ]]; then
        echo -e "${RED}❌ Failed: The SSL certificate does not exist yet${NC}"
        echo -e "${YELLOW}This typically means GitHub is still provisioning your certificate.${NC}"
        echo -e "${YELLOW}Wait 24-48 hours after DNS configuration before trying again.${NC}"
    else
        echo -e "${RED}❌ Failed to enable HTTPS:${NC}"
        echo "$ENABLE_RESULT"
    fi
    
    echo -e "\n${YELLOW}Troubleshooting steps:${NC}"
    echo "1. Ensure DNS is properly configured with all GitHub Pages IP addresses"
    echo "2. Verify that the domain is correctly set in GitHub repository settings"
    echo "3. Check that the DNS changes have fully propagated (can take up to 48 hours)"
    echo "4. Make sure your repository visibility settings allow GitHub Pages"
fi