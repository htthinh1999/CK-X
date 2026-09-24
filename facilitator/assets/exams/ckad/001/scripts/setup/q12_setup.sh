#!/bin/bash

# Setup for Question 12: Create a CronJob for log cleaning

# Create the workloads namespace if it doesn't exist already
if ! kubectl get namespace workloads &> /dev/null; then
    kubectl create namespace workloads
fi

# Delete any existing CronJob with the same name
kubectl delete cronjob log-cleaner -n workloads --ignore-not-found=true

# Create a directory with some sample log files for demonstration
mkdir -p /tmp/var/log
touch /tmp/var/log/test1.log
touch /tmp/var/log/test2.log
touch /tmp/var/log/app.log
touch /tmp/var/log/system.log

echo "Setup complete for Question 12: Environment ready for creating CronJob 'log-cleaner'"
echo "Note: In a real environment, log files would be on the host system. These sample files"
echo "      are for demonstration only and won't actually be accessible from the CronJob."
exit 0 