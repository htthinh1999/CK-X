#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
n=$(kubectl get pod app-with-wait -n storm -o jsonpath='{.spec.initContainers[0].name}' 2>/dev/null)
if [ "$n" = "wait-for-db" ]; then echo "Success: init container wait-for-db exists"; exit 0; fi
echo "Error: init container name is '$n', expected wait-for-db"; exit 1
