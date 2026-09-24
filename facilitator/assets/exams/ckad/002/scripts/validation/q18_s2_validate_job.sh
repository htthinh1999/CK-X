#!/bin/bash

# Validate that the data-processor job exists
JOB=$(kubectl get job data-processor -n jobs -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$JOB" == "data-processor" ]]; then
    echo "✅ Job 'data-processor' exists in namespace 'jobs'."

    # Check image
    IMAGE=$(kubectl get job data-processor -n jobs -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

    # Get full command string
    COMMAND=$(kubectl get job data-processor -n jobs -o jsonpath='{.spec.template.spec.containers[0].command[*]}' 2>/dev/null)

    # Use relaxed matching instead of strict string comparison
    if [[ "$IMAGE" == "busybox" && "$COMMAND" == *"Processing item"* && "$COMMAND" == *"sleep 2"* ]]; then
        echo "✅ Job has the correct image and command logic."
        exit 0
    else
        echo "❌ Job 'data-processor' does not have correct specifications."
        echo "   ➤ Found image: $IMAGE (expected: busybox)"
        echo "   ➤ Found command: $COMMAND"
        echo "   ➤ Expected command to include: 'Processing item' and 'sleep 2'"
        exit 1
    fi
else
    echo "❌ Job 'data-processor' does not exist in the 'jobs' namespace."
    exit 1
fi
