#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get clusterrole secret-reader -o jsonpath='{.rules[0].resources[0]}' 2>/dev/null)
if [ "$r" = "secrets" ]; then echo "Success: first rule resource is secrets"; exit 0; fi
echo "Error: first rule resource is '$r', expected secrets"; exit 1
