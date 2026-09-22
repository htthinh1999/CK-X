#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
i=$(kubectl get job cleanup-job -n stripe -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if echo "$i" | grep -q "busybox:1.36"; then echo "Success: image busybox:1.36"; exit 0; else echo "Error: image='$i' expected busybox:1.36"; exit 1; fi
