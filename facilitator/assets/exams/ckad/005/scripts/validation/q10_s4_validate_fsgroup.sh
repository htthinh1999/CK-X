#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.securityContext.fsGroup}' 2>/dev/null)
if [ "$v" = "2000" ]; then echo "Success: fsGroup 2000"; exit 0; else echo "Error: fsGroup='$v' expected 2000"; exit 1; fi
