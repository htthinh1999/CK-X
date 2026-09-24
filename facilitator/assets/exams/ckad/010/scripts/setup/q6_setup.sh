#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"


mkdir -p /tmp/exam/course/6 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true

echo "Setup complete for Question 6"
exit 0
