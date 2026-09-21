#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get daemonset node-monitor -n deep -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$val" = "monitor" ]; then echo "Success: container name is monitor"; exit 0; else echo "Error: container name is '$val', expected monitor"; exit 1; fi
