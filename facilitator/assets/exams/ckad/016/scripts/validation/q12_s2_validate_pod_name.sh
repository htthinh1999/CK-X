#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod env-info -n thunder -o jsonpath='{.spec.containers[0].env[?(@.name=="POD_NAME")].valueFrom.fieldRef.fieldPath}' 2>/dev/null)
if [ "$v" = "metadata.name" ]; then echo "Success: POD_NAME mapped to metadata.name"; exit 0; fi
echo "Error: POD_NAME fieldPath is '$v', expected metadata.name"; exit 1
