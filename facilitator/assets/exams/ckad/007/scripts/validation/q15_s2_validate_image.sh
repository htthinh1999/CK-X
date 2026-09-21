#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment patch-demo -n tide -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$val" = "nginx:1.22" ]; then echo "Success: image is nginx:1.22"; exit 0; else echo "Error: image is '$val', expected nginx:1.22"; exit 1; fi
