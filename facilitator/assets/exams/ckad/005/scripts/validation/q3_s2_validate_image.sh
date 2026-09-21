#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
i=$(kubectl get deployment stable-green -n stripe -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if echo "$i" | grep -q "nginx:1.22"; then echo "Success: image nginx:1.22"; exit 0; else echo "Error: image='$i' expected nginx:1.22"; exit 1; fi
