#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: readOnlyRootFilesystem true"; exit 0; else echo "Error: readOnlyRootFilesystem='$v' expected true"; exit 1; fi
