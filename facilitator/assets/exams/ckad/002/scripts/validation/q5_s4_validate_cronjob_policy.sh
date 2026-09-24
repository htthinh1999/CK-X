#!/bin/bash

# Validate that the CronJob has correct restart policy and deadline
CRONJOB=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$CRONJOB" == "backup-job" ]]; then
    # CronJob exists, now check restart policy and deadline
    
    # Check restart policy
    RESTART_POLICY=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null)
    
    # Check active deadline seconds
    DEADLINE=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
    
    if [[ "$RESTART_POLICY" == "OnFailure" && "$DEADLINE" == "100" ]]; then
        # CronJob has correct restart policy and deadline
        exit 0
    else
        echo "CronJob 'backup-job' does not have correct restart policy or deadline."
        echo "Found restart policy: $RESTART_POLICY (expected: OnFailure)"
        echo "Found active deadline seconds: $DEADLINE (expected: 100)"
        exit 1
    fi
else
    # CronJob does not exist
    echo "CronJob 'backup-job' does not exist in the 'pod-design' namespace"
    exit 1
fi 