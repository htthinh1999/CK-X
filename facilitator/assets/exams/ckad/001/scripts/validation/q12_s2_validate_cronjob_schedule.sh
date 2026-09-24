#!/bin/bash

# Validate if the CronJob 'log-cleaner' has the correct schedule (every hour)
SCHEDULE=$(kubectl get cronjob log-cleaner -n workloads -o jsonpath='{.spec.schedule}' 2>/dev/null)

if [ "$SCHEDULE" = "0 * * * *" ] || [ "$SCHEDULE" = "@hourly" ]; then
    echo "Success: CronJob 'log-cleaner' has the correct schedule (every hour): $SCHEDULE"
    exit 0
else
    echo "Error: CronJob 'log-cleaner' does not have the correct schedule"
    echo "Expected: '0 * * * *' or '@hourly', Found: '$SCHEDULE'"
    exit 1
fi 