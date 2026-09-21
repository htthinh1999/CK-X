#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod shared-pid -n artemis >/dev/null 2>&1; then echo "Success: pod shared-pid exists"; exit 0; else echo "Error: pod shared-pid not found in artemis"; exit 1; fi
