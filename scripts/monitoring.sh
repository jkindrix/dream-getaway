#!/bin/bash
# Monitoring script for yesiboughtadomainforthis.com
# This script checks the health of the website and sends alerts if issues are detected

# Configuration
DOMAIN="yesiboughtadomainforthis.com"
SLACK_WEBHOOK="YOUR_SLACK_WEBHOOK_URL" # Replace with your Slack webhook
EMAIL="admin@example.com" # Replace with your email
CHECK_INTERVAL=300 # Check every 5 minutes
MAX_RESPONSE_TIME=2000 # Maximum acceptable response time in ms
LOG_FILE="monitoring.log"
ALERT_THRESHOLD=3 # Number of consecutive failures before alerting

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Function to send email alert
send_email_alert() {
  if [[ -n "$EMAIL" ]]; then
    echo "ALERT: $1" | mail -s "Website Monitoring Alert: $DOMAIN" $EMAIL
    log "Email alert sent to $EMAIL"
  fi
}

# Function to send Slack alert
send_slack_alert() {
  if [[ -n "$SLACK_WEBHOOK" && "$SLACK_WEBHOOK" != "YOUR_SLACK_WEBHOOK_URL" ]]; then
    curl -s -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"ALERT: $DOMAIN - $1\"}" \
      $SLACK_WEBHOOK > /dev/null
    log "Slack alert sent"
  fi
}

# Function to check website availability
check_website() {
  log "Checking website $DOMAIN..."
  
  # Check if the website is up
  RESPONSE=$(curl -s -w "%{http_code}|%{time_total}|%{size_download}" -o /dev/null $DOMAIN)
  HTTP_CODE=$(echo $RESPONSE | cut -d'|' -f1)
  RESPONSE_TIME=$(echo $RESPONSE | cut -d'|' -f2)
  RESPONSE_TIME_MS=$(echo "$RESPONSE_TIME * 1000" | bc | cut -d'.' -f1)
  SIZE=$(echo $RESPONSE | cut -d'|' -f3)
  
  # Calculate response time in readable format
  if [[ $RESPONSE_TIME_MS -lt 1000 ]]; then
    READABLE_RT="${RESPONSE_TIME_MS}ms"
  else
    READABLE_RT="$(echo "scale=2; $RESPONSE_TIME_MS/1000" | bc)s"
  fi
  
  # Check if the website returns 200 OK
  if [[ $HTTP_CODE -eq 200 ]]; then
    log "${GREEN}✅ Website is UP (HTTP $HTTP_CODE) - Response time: $READABLE_RT - Size: $SIZE bytes${NC}"
    
    # Check if response time is acceptable
    if [[ $RESPONSE_TIME_MS -gt $MAX_RESPONSE_TIME ]]; then
      log "${YELLOW}⚠️ Response time ($READABLE_RT) exceeds maximum acceptable time ($MAX_RESPONSE_TIME ms)${NC}"
      CONSECUTIVE_SLOW_RESPONSE=$((CONSECUTIVE_SLOW_RESPONSE + 1))
      
      if [[ $CONSECUTIVE_SLOW_RESPONSE -ge $ALERT_THRESHOLD ]]; then
        ALERT_MESSAGE="Slow response time detected: $READABLE_RT (threshold: ${MAX_RESPONSE_TIME}ms)"
        send_email_alert "$ALERT_MESSAGE"
        send_slack_alert "$ALERT_MESSAGE"
        CONSECUTIVE_SLOW_RESPONSE=0
      fi
    else
      CONSECUTIVE_SLOW_RESPONSE=0
    fi
    
    CONSECUTIVE_FAILURES=0
  else
    log "${RED}❌ Website is DOWN (HTTP $HTTP_CODE)${NC}"
    CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    
    if [[ $CONSECUTIVE_FAILURES -ge $ALERT_THRESHOLD ]]; then
      ALERT_MESSAGE="Website is DOWN! HTTP Status: $HTTP_CODE"
      send_email_alert "$ALERT_MESSAGE"
      send_slack_alert "$ALERT_MESSAGE"
      CONSECUTIVE_FAILURES=0
    fi
  fi
  
  # Check SSL certificate expiration
  SSL_EXPIRES=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
  if [[ -n "$SSL_EXPIRES" ]]; then
    SSL_EXPIRY_DATE=$(date -d "$SSL_EXPIRES" +%s)
    CURRENT_DATE=$(date +%s)
    DAYS_LEFT=$(( ($SSL_EXPIRY_DATE - $CURRENT_DATE) / 86400 ))
    
    if [[ $DAYS_LEFT -lt 30 ]]; then
      log "${YELLOW}⚠️ SSL Certificate expires in $DAYS_LEFT days${NC}"
      
      if [[ $DAYS_LEFT -lt 15 ]]; then
        ALERT_MESSAGE="SSL Certificate expires in $DAYS_LEFT days!"
        send_email_alert "$ALERT_MESSAGE"
        send_slack_alert "$ALERT_MESSAGE"
      fi
    else
      log "${GREEN}✅ SSL Certificate valid for $DAYS_LEFT more days${NC}"
    fi
  else
    log "${RED}❌ Could not retrieve SSL certificate information${NC}"
  fi
}

# Initialize failure counters
CONSECUTIVE_FAILURES=0
CONSECUTIVE_SLOW_RESPONSE=0

# Create log file if it doesn't exist
touch $LOG_FILE

# Main monitoring loop
log "Starting monitoring for $DOMAIN"
log "Checking every $CHECK_INTERVAL seconds, alerting after $ALERT_THRESHOLD consecutive failures"
log "Maximum acceptable response time: ${MAX_RESPONSE_TIME}ms"

# Run initial check
check_website

# If script is run with --daemon flag, continue monitoring
if [[ "$1" == "--daemon" ]]; then
  log "Running in daemon mode. Press Ctrl+C to stop."
  
  while true; do
    sleep $CHECK_INTERVAL
    check_website
  done
else
  log "Single check completed. Run with --daemon flag for continuous monitoring."
fi