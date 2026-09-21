#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].securityContext.runAsNonRoot}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: runAsNonRoot true"; exit 0; else echo "Error: runAsNonRoot='$v' expected true"; exit 1; fi
