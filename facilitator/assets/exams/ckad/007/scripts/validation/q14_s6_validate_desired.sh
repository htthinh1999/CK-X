#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get daemonset node-monitor -n deep -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null)
if [ "$val" -ge 1 ] 2>/dev/null; then echo "Success: desiredNumberScheduled ($val >= 1)"; exit 0; else echo "Error: desiredNumberScheduled is '$val', expected >= 1"; exit 1; fi
