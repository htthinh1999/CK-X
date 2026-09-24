#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
name=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
ed=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ -n "$name" ] && [ -n "$ed" ]; then echo "Success: shared emptyDir volume $name exists"; exit 0
else echo "Error: shared emptyDir volume not found (name=$name)"; exit 1; fi
