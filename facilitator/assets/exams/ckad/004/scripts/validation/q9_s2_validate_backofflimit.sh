#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get job retry-job -n artemis -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
if [ "$v" = "3" ]; then echo "Success: backoffLimit 3"; exit 0; else echo "Error: backoffLimit is '$v', expected 3"; exit 1; fi
