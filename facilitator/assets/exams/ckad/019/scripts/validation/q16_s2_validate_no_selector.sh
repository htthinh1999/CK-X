#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl get svc external-db -n outpost -o jsonpath='{.spec.selector}' 2>/dev/null)
if [ -z "$sel" ] || [ "$sel" = "{}" ]; then echo "Success: service has no selector"; exit 0; fi
echo "Error: service selector is '$sel', expected none"; exit 1
