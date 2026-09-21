#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod ambassador-pod -n olympus -o jsonpath='{.spec.containers[?(@.name=="app")].image}' 2>/dev/null)
if [ "$v" = "nginx:1.21" ]; then echo "Success: app image nginx:1.21"; exit 0; else echo "Error: app image is '$v', expected nginx:1.21"; exit 1; fi
