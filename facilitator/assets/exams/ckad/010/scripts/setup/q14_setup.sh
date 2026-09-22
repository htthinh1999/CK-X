#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"


mkdir -p /tmp/exam/course/14 || true
chown -R candidate:candidate /tmp/exam 2>/dev/null || true
# The `bitnami` repo is NOT added here: Question 13 (same server) has the student
# add it, and adding it here would hand them Question 13's points for free.

echo "Setup complete for Question 14"
exit 0
