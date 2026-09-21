#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy secure-app -n cascade -o jsonpath='{.spec.template.spec.securityContext.runAsUser}' 2>/dev/null)
if [ "$v" = "1000" ]; then echo "Success: pod-level runAsUser is 1000"; exit 0; else echo "Error: runAsUser is '$v', expected 1000"; exit 1; fi
