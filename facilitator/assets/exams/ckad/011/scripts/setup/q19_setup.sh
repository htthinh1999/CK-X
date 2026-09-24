#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# File-based: student saves `kubectl top nodes` output.
mkdir -p /tmp/exam/course/19 || true

echo "Setup complete for Question 19"
exit 0
