#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod shared-pid -n artemis -o jsonpath='{.spec.shareProcessNamespace}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: shareProcessNamespace enabled"; exit 0; else echo "Error: shareProcessNamespace is '$v', expected true"; exit 1; fi
