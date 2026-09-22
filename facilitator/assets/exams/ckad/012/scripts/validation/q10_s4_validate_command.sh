#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cmd=$(kubectl get cronjob cleanup-job -n stronghold -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].command}' 2>/dev/null)
args=$(kubectl get cronjob cleanup-job -n stronghold -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].args}' 2>/dev/null)
if echo "$cmd" | grep -q "echo" || echo "$args" | grep -q "echo" || echo "$cmd" | grep -q "sh"; then
  echo "Success: command set"; exit 0
else echo "Error: command missing or incorrect"; exit 1; fi
