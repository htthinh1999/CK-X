#!/bin/bash

# Validate that the CronJob uses correct image and command
CRONJOB=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$CRONJOB" == "backup-job" ]]; then
    # CronJob exists, now check image and command
    
    # Check image
    IMAGE=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
    
    # Check command
    COMMAND=$(kubectl get cronjob backup-job -n pod-design -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].command}' 2>/dev/null)
    
    if [[ "$IMAGE" == "busybox" && 
          "$COMMAND" == *"sh"* && 
          "$COMMAND" == *"-c"* && 
          "$COMMAND" == *"echo Backup started"* && 
          "$COMMAND" == *"sleep 30"* && 
          "$COMMAND" == *"echo Backup completed"* ]]; then
        # CronJob has correct image and command
        exit 0
    else
        echo "CronJob 'backup-job' does not use correct image or command."
        echo "Found image: $IMAGE (expected: busybox)"
        echo "Found command: $COMMAND (expected to contain: sh, -c, echo Backup started, sleep 30, echo Backup completed)"
        exit 1
    fi
else
    # CronJob does not exist
    echo "CronJob 'backup-job' does not exist in the 'pod-design' namespace"
    exit 1
fi 