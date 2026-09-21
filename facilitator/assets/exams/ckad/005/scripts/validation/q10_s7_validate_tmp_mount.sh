#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod secure-pod -n stalker -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/tmp")].name}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: emptyDir mounted at /tmp"; exit 0; else echo "Error: no volume mounted at /tmp"; exit 1; fi
