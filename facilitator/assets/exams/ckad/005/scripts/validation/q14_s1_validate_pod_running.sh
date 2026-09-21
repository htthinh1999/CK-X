#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get pod metadata-pod -n claw -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$p" = "Running" ]; then echo "Success: pod metadata-pod running"; exit 0; else echo "Error: pod phase='$p' expected Running"; exit 1; fi
