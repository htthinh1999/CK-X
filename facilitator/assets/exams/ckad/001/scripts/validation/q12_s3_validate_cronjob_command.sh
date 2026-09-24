#!/bin/bash

CRONJOB_NAME="log-cleaner"
NAMESPACE="workloads"

# Expected values
EXPECTED_COMMAND='["/bin/sh","-c"]'
EXPECTED_ARGS='find /var/log -type f -name "*.log" -mtime +7 -delete'

# Fetch actual values from the CronJob
ACTUAL_COMMAND=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.jobTemplate.spec.template.spec.containers[0].command}")
ACTUAL_ARGS=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.jobTemplate.spec.template.spec.containers[0].args[0]}")

# Compare
if [[ "$ACTUAL_COMMAND" == "$EXPECTED_COMMAND" && "$ACTUAL_ARGS" == "$EXPECTED_ARGS" ]]; then
    echo "✅ Success: CronJob '$CRONJOB_NAME' has the correct command and args"
    exit 0
else
    echo "❌ Error: CronJob '$CRONJOB_NAME' does not have the correct command/args"
    echo "Actual command: $ACTUAL_COMMAND"
    echo "Actual args: $ACTUAL_ARGS"
    exit 1
fi
