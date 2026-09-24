#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/12/events.txt"
if [ -f "$f" ]; then echo "Success: events.txt exists"; exit 0; fi
echo "Error: $f not found"; exit 1
