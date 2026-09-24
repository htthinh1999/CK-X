#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ports=$(kubectl get netpol protect-db -n vanguard -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null)
case "$ports" in *5432*) echo "Success: port 5432 allowed"; exit 0;; esac
echo "Error: ingress ports '$ports' do not include 5432"; exit 1
