#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod titan-alpha -n zeus -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$v" = "nginx:1.21" ]; then echo "Success: image nginx:1.21"; exit 0; else echo "Error: image is '$v', expected nginx:1.21"; exit 1; fi
