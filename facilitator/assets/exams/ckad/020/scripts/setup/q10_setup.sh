#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace zenith --dry-run=client -o yaml | kubectl apply -f - || true

# Course dir for the events export
mkdir -p /tmp/exam/course/10

# Generate some events in the zenith namespace so there is data to export
kubectl run zenith-evt --image=nginx:doesnotexist -n zenith --restart=Never >/dev/null 2>&1 || true

echo "Setup complete for Question 10"
exit 0
