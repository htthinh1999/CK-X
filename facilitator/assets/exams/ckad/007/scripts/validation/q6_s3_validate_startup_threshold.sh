#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod slow-starter -n wave -o jsonpath='{.spec.containers[0].startupProbe.failureThreshold}' 2>/dev/null)
if [ "$val" = "30" ]; then echo "Success: startupProbe failureThreshold is 30"; exit 0; else echo "Error: startupProbe failureThreshold is '$val', expected 30"; exit 1; fi
