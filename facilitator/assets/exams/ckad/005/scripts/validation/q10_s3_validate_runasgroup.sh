#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.securityContext.runAsGroup}' 2>/dev/null)
if [ "$v" = "3000" ]; then echo "Success: runAsGroup 3000"; exit 0; else echo "Error: runAsGroup='$v' expected 3000"; exit 1; fi
