#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
tz=$(kubectl get cj siege-report -n siege -o jsonpath='{.spec.timeZone}' 2>/dev/null)
[ "$tz" = "Asia/Tokyo" ] && { echo "Success: timeZone is Asia/Tokyo"; exit 0; }
echo "Error: timeZone is '$tz', expected Asia/Tokyo"; exit 1
