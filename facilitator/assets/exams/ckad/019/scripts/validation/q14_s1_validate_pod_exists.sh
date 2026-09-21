#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod secure-workload -n bastion >/dev/null 2>&1 && { echo "Success: pod secure-workload exists"; exit 0; }
echo "Error: pod secure-workload not found"; exit 1
