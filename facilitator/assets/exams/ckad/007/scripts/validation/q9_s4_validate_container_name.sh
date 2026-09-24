#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod network-diagnostic -n coral -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$val" = "netshoot" ]; then echo "Success: container name is netshoot"; exit 0; else echo "Error: container name is '$val', expected netshoot"; exit 1; fi
