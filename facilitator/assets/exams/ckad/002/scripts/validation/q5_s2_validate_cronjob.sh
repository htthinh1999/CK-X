#!/bin/bash

# Validate that the backup-job CronJob exists with correct name and schedule
CRONJOB=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$CRONJOB" == "backup-job" ]]; then
    # CronJob exists, now check schedule
    SCHEDULE=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.spec.schedule}' 2>/dev/null)
    
    if [[ "$SCHEDULE" == "*/5 * * * *" ]]; then
        # CronJob has correct schedule
        exit 0
    else
        echo "CronJob 'backup-job' does not have correct schedule. Found: $SCHEDULE (expected: */5 * * * *)"
        exit 1
    fi
else
    # CronJob does not exist
    echo "CronJob 'backup-job' does not exist in the 'pod-design' namespace"
    exit 1
fi 