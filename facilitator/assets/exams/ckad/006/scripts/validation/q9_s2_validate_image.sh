#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy app-v1 -n brook -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$v" = "nginx:1.20" ]; then echo "Success: image is nginx:1.20 (rolled back)"; exit 0; else echo "Error: image is '$v', expected nginx:1.20"; exit 1; fi
