#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sch=$(kubectl get cj siege-report -n siege -o jsonpath='{.spec.schedule}' 2>/dev/null)
[ "$sch" = "30 * * * *" ] && { echo "Success: schedule is 30 * * * *"; exit 0; }
echo "Error: schedule is '$sch', expected 30 * * * *"; exit 1
