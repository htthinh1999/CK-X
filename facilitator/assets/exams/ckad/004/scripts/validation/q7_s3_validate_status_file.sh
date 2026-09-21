#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/7/rollout-status.txt"
if [ -f "$f" ] && [ -s "$f" ]; then echo "Success: rollout status file present and non-empty"; exit 0; else echo "Error: $f missing or empty"; exit 1; fi
