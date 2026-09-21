#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
l=$(kubectl get deployment backend-v2 -n spark -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$l" = "backend" ]; then echo "Success: pod template label app=backend"; exit 0; fi
echo "Error: template label app is '$l', expected backend"; exit 1
