#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod secret-consumer -n deep >/dev/null 2>&1; then echo "Success: pod secret-consumer exists in deep"; exit 0; else echo "Error: pod secret-consumer not found in deep"; exit 1; fi
