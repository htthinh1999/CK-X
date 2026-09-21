#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod critical-pod -n tide -o jsonpath='{.spec.priorityClassName}' 2>/dev/null)
if [ "$val" = "critical-priority" ]; then echo "Success: priorityClassName is critical-priority"; exit 0; else echo "Error: priorityClassName is '$val', expected critical-priority"; exit 1; fi
