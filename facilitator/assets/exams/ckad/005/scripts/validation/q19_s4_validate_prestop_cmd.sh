#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod graceful-pod -n tiger -o json 2>/dev/null | grep -q "nginx -s quit"; then echo "Success: preStop gracefully stops nginx"; exit 0; else echo "Error: preStop does not contain 'nginx -s quit'"; exit 1; fi
