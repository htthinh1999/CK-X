#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod secure-app -n hades -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: readOnlyRootFilesystem enabled"; exit 0; else echo "Error: readOnlyRootFilesystem is '$v', expected true"; exit 1; fi
