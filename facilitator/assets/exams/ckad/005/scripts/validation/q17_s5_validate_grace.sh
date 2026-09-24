#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod graceful-pod -n tiger -o jsonpath='{.spec.terminationGracePeriodSeconds}' 2>/dev/null)
if [ "$v" = "30" ]; then echo "Success: terminationGracePeriodSeconds 30"; exit 0; else echo "Error: terminationGracePeriodSeconds='$v' expected 30"; exit 1; fi
