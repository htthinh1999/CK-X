#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace zenith --dry-run=client -o yaml | kubectl apply -f - || true

# Course dir for the events export
mkdir -p /tmp/exam/course/5

# Generate some events in the zenith namespace so there is data to export
kubectl run zenith-evt --image=nginx:doesnotexist -n zenith --restart=Never >/dev/null 2>&1 || true

echo "Setup complete for Question 5"
exit 0
