#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cmd=$(kubectl get job batch-processor -n bulwark -o jsonpath='{.spec.template.spec.containers[0].command}' 2>/dev/null)
args=$(kubectl get job batch-processor -n bulwark -o jsonpath='{.spec.template.spec.containers[0].args}' 2>/dev/null)
if echo "$cmd" | grep -q "echo" || echo "$args" | grep -q "echo" || echo "$cmd" | grep -q "sh"; then
  echo "Success: command set"; exit 0
else echo "Error: command missing"; exit 1; fi
