#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cpu=$(kubectl get deploy weapon-smith -n armory -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
mem=$(kubectl get deploy weapon-smith -n armory -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
[ "$cpu" = "100m" ] && [ "$mem" = "128Mi" ] && { echo "Success: requests are 100m/128Mi"; exit 0; }
echo "Error: requests are cpu='$cpu' mem='$mem', expected 100m/128Mi"; exit 1
