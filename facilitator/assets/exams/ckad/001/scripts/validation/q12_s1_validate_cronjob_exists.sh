#!/bin/bash

# Validate if the CronJob 'log-cleaner' exists in the 'workloads' namespace
if kubectl get cronjob log-cleaner -n workloads &> /dev/null; then
    echo "Success: CronJob 'log-cleaner' exists in namespace 'workloads'"
    exit 0
else
    echo "Error: CronJob 'log-cleaner' does not exist in namespace 'workloads'"
    exit 1
fi 