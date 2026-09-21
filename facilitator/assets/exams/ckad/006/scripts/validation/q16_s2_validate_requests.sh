#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get pod resource-pod -n pond -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
m=$(kubectl get pod resource-pod -n pond -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
if [ -n "$c" ] && [ -n "$m" ]; then echo "Success: pod has resource requests (cpu=$c mem=$m)"; exit 0; else echo "Error: missing requests (cpu='$c' mem='$m')"; exit 1; fi
