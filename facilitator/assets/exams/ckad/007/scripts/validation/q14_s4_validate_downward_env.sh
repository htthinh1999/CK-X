#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get daemonset node-monitor -n deep -o jsonpath='{.spec.template.spec.containers[0].env[*].valueFrom.fieldRef.fieldPath}' 2>/dev/null | grep -q "spec.nodeName"; then echo "Success: NODE_NAME downward API"; exit 0; else echo "Error: NODE_NAME downward API - not found"; exit 1; fi
