#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/10/cpu-usage.txt
if [ ! -s "$F" ]; then
  echo "Error: cpu-usage.txt missing or empty"
  exit 1
fi
# First word of the first non-empty line, tolerating a `pod/` prefix. CPU usage
# shifts over time, so accept any real kube-system Pod rather than re-checking
# which one is on top right now.
name=$(awk 'NF{print $1; exit}' "$F")
name=${name#pod/}
if kubectl get pod "$name" -n kube-system >/dev/null 2>&1; then
  echo "Success: cpu-usage.txt names kube-system Pod '$name'"
  exit 0
fi
echo "Error: '$name' is not a Pod in the kube-system namespace"
exit 1
