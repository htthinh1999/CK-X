#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment spread-pods -n tiger -o jsonpath='{.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution}' 2>/dev/null)
if [ -n "$r" ]; then echo "Success: uses requiredDuringSchedulingIgnoredDuringExecution"; exit 0; else echo "Error: requiredDuringSchedulingIgnoredDuringExecution not set"; exit 1; fi
