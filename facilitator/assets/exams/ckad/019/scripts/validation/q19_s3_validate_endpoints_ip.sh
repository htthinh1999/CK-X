#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ip=$(kubectl get endpoints external-db -n outpost -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)
[ "$ip" = "10.50.50.50" ] && { echo "Success: endpoints IP is 10.50.50.50"; exit 0; }
echo "Error: endpoints IP is '$ip', expected 10.50.50.50"; exit 1
