#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get ingress web-ingress -n eddy -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$v" = "web.example.com" ]; then echo "Success: host is web.example.com"; exit 0; else echo "Error: host is '$v', expected web.example.com"; exit 1; fi
