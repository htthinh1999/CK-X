#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

cpu=$(kubectl get quota cliff-quota -n cliff -o jsonpath='{.spec.hard.cpu}' 2>/dev/null)
cpul=$(kubectl get quota cliff-quota -n cliff -o jsonpath='{.spec.hard.limits\.cpu}' 2>/dev/null)
if [ "$cpu" = "1" ] || [ "$cpul" = "1" ]; then echo "Success: CPU limit is 1"; exit 0; else echo "Error: cpu=$cpu limits.cpu=$cpul"; exit 1; fi
