#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
sp=$(kubectl get pod process-monitor -n bastion -o jsonpath='{.spec.shareProcessNamespace}' 2>/dev/null)
[ "$sp" = "true" ] && { echo "Success: shareProcessNamespace is true"; exit 0; }
echo "Error: shareProcessNamespace is '$sp', expected true"; exit 1
