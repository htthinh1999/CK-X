#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

args=$(kubectl get pod debug-pod -n meadow -o jsonpath='{.spec.containers[0].args}' 2>/dev/null)
cmd=$(kubectl get pod debug-pod -n meadow -o jsonpath='{.spec.containers[0].command}' 2>/dev/null)
if [[ "$args" == *"notexist"* ]] || [[ "$cmd" == *"notexist"* ]]; then
  echo "Success: error command configured"; exit 0
else
  echo "Error: command does not reference /notexist"; exit 1
fi
