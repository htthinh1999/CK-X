#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get daemonset node-monitor -n deep -o jsonpath='{.spec.template.spec.tolerations[*].key}' 2>/dev/null | grep -q "node-role.kubernetes.io/control-plane"; then echo "Success: control-plane toleration"; exit 0; else echo "Error: control-plane toleration - not found"; exit 1; fi
