#!/bin/bash

# Validate that the job has correct active deadline seconds
ACTIVE_DEADLINE_SECONDS=$(kubectl get job data-processor -n jobs -o jsonpath='{.spec.activeDeadlineSeconds}' 2>/dev/null)

if [[ "$ACTIVE_DEADLINE_SECONDS" == "30" ]]; then
    # Active deadline seconds is correct
    exit 0
else
    echo "Job 'data-processor' does not have correct active deadline seconds. Found: $ACTIVE_DEADLINE_SECONDS (expected: 30)"
    exit 1
fi 