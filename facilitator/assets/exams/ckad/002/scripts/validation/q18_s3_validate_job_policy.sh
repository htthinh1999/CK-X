#!/bin/bash

# Validate that the job has correct restart policy and backoff limit
# Check restart policy
RESTART_POLICY=$(kubectl get job data-processor -n jobs -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null)

# Check backoff limit
BACKOFF_LIMIT=$(kubectl get job data-processor -n jobs -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)

if [[ "$RESTART_POLICY" == "Never" ]]; then
    # Restart policy is correct
    if [[ "$BACKOFF_LIMIT" == "4" ]]; then
        # Backoff limit is correct
        exit 0
    else
        echo "Job 'data-processor' does not have correct backoff limit. Found: $BACKOFF_LIMIT (expected: 4)"
        exit 1
    fi
else
    echo "Job 'data-processor' does not have correct restart policy. Found: $RESTART_POLICY (expected: Never)"
    exit 1
fi 