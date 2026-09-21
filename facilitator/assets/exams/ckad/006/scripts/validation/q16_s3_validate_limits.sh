#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get pod resource-pod -n pond -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
m=$(kubectl get pod resource-pod -n pond -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
if [ -n "$c" ] && [ -n "$m" ]; then echo "Success: pod has resource limits (cpu=$c mem=$m)"; exit 0; else echo "Error: missing limits (cpu='$c' mem='$m')"; exit 1; fi
