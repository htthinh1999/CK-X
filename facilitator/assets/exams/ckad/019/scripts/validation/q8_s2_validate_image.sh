#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get deploy vanguard-web -n vanguard -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:1.23.0-alpine" ] && { echo "Success: image is nginx:1.23.0-alpine"; exit 0; }
echo "Error: image is '$img', expected nginx:1.23.0-alpine"; exit 1
