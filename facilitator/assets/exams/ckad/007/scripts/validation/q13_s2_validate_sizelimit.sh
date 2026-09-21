#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod cache-pod -n reef -o jsonpath='{.spec.volumes[*].emptyDir.sizeLimit}' 2>/dev/null | grep -q "100Mi"; then echo "Success: emptyDir sizeLimit 100Mi"; exit 0; else echo "Error: emptyDir sizeLimit 100Mi - not found"; exit 1; fi
