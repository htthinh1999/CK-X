#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get deployment backend-v2 -n spark -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$img" = "nginx:1.23" ]; then echo "Success: image nginx:1.23"; exit 0; fi
echo "Error: image is '$img', expected nginx:1.23"; exit 1
