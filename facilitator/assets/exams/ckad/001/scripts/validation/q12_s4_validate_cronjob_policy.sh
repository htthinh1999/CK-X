#!/bin/bash

CRONJOB_NAME="log-cleaner"
NAMESPACE="workloads"

# Expected values
EXPECTED_CONCURRENCY_POLICY="Forbid"
EXPECTED_SUCCESSFUL_LIMIT="3"
EXPECTED_FAILED_LIMIT="1"

# Fetch actual values from the CronJob spec
ACTUAL_CONCURRENCY_POLICY=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.concurrencyPolicy}")
ACTUAL_SUCCESSFUL_LIMIT=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.successfulJobsHistoryLimit}")
ACTUAL_FAILED_LIMIT=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.failedJobsHistoryLimit}")

# Compare
if [[ "$ACTUAL_CONCURRENCY_POLICY" == "$EXPECTED_CONCURRENCY_POLICY" && \
      "$ACTUAL_SUCCESSFUL_LIMIT" == "$EXPECTED_SUCCESSFUL_LIMIT" && \
      "$ACTUAL_FAILED_LIMIT" == "$EXPECTED_FAILED_LIMIT" ]]; then
    echo "✅ Success: CronJob '$CRONJOB_NAME' has correct concurrency policy and history limits"
    exit 0
else
    echo "❌ Error: CronJob '$CRONJOB_NAME' has incorrect concurrency policy or history limits"
    echo "ConcurrencyPolicy: $ACTUAL_CONCURRENCY_POLICY (expected: $EXPECTED_CONCURRENCY_POLICY)"
    echo "SuccessfulJobsHistoryLimit: $ACTUAL_SUCCESSFUL_LIMIT (expected: $EXPECTED_SUCCESSFUL_LIMIT)"
    echo "FailedJobsHistoryLimit: $ACTUAL_FAILED_LIMIT (expected: $EXPECTED_FAILED_LIMIT)"
    exit 1
fi
