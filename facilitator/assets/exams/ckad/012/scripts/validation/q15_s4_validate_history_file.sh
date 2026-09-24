#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/15/rollout-history.txt" ]; then echo "Success: rollout history file saved"; exit 0
else echo "Error: rollout history file not found at /tmp/exam/course/15/rollout-history.txt"; exit 1; fi
