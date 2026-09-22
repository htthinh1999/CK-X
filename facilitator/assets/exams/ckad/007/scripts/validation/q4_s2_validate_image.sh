#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get daemonset node-monitor -n deep -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null | grep -q "busybox"; then echo "Success: image contains busybox"; exit 0; else echo "Error: image contains busybox - not found"; exit 1; fi
