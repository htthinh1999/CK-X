#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cmd=$(kubectl get job pi-job -n coral -o jsonpath='{.spec.template.spec.containers[0].command}' 2>/dev/null)
case "$cmd" in
  *bpi*) echo "Success: command calculates Pi (contains bpi)"; exit 0 ;;
  *) echo "Error: command does not contain bpi"; exit 1 ;;
esac
