#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get daemonset node-monitor -n deep >/dev/null 2>&1; then echo "Success: daemonset node-monitor exists in deep"; exit 0; else echo "Error: daemonset node-monitor not found in deep"; exit 1; fi
