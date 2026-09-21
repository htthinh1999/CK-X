#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod web-setup -n fortress >/dev/null 2>&1 && { echo "Success: pod web-setup exists"; exit 0; }
echo "Error: pod web-setup not found"; exit 1
