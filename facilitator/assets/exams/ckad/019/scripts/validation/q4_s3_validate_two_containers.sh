#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cnt=$(kubectl get pod process-monitor -n bastion -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' 2>/dev/null | wc -l)
[ "$cnt" -eq 2 ] && { echo "Success: pod has two containers"; exit 0; }
echo "Error: container count is '$cnt', expected 2"; exit 1
