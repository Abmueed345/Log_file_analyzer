#!/bin/bash

# ---------------------------------------
# Log Analyzer Script - analyzeslog.sh
# ---------------------------------------

# Terminal Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if log file path is passed
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <log_file_path>${NC}"
    exit 1
fi

LOG_FILE="$1"

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}Error: File '$LOG_FILE' not found.${NC}"
    exit 1
fi

# Count log levels
ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")
WARNING_COUNT=$(grep -c "WARNING" "$LOG_FILE")
INFO_COUNT=$(grep -c "INFO" "$LOG_FILE")

# Display counts
echo -e "${CYAN}===== Log Level Counts =====${NC}"
echo -e "${RED}ERRORS:   $ERROR_COUNT${NC}"
echo -e "${YELLOW}WARNINGS: $WARNING_COUNT${NC}"
echo -e "${GREEN}INFO:     $INFO_COUNT${NC}"

# Display top 5 most common ERROR messages
echo -e "\n${CYAN}===== Top 5 ERROR Messages =====${NC}"
grep "ERROR" "$LOG_FILE" | \
sed -E 's/.*ERROR[[:space:]]*[:-]*[[:space:]]*//' | \
sort | uniq -c | sort -nr | head -5

# Extract first and last ERROR timestamps
FIRST_ERROR=$(grep "ERROR" "$LOG_FILE" | head -1 | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')
LAST_ERROR=$(grep "ERROR" "$LOG_FILE" | tail -1 | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')

# Display summary
echo -e "\n${CYAN}===== Summary Report =====${NC}"
if [ -n "$FIRST_ERROR" ]; then
    echo -e "${RED}First ERROR at: $FIRST_ERROR${NC}"
    echo -e "${RED}Last  ERROR at: $LAST_ERROR${NC}"
else
    echo -e "${YELLOW}No ERROR entries found in the log.${NC}"
fi

