#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod ambassador-pod -n olympus >/dev/null 2>&1; then echo "Success: pod ambassador-pod exists"; exit 0; else echo "Error: pod ambassador-pod not found in olympus"; exit 1; fi
