#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace rhythm --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete configmap binary-config -n rhythm --ignore-not-found=true 2>/dev/null || true
mkdir -p /tmp/exam/course/13
printf 'binary-data-test' > /tmp/exam/course/13/data.bin
echo "Setup complete for Question 13"
exit 0
