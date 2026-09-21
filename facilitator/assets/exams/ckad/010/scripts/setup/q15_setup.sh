#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig


mkdir -p /tmp/exam/course/15 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true

echo "Setup complete for Question 15"
exit 0
