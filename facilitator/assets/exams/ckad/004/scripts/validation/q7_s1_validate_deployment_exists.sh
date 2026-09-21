#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment battle-app -n ares >/dev/null 2>&1; then echo "Success: deployment battle-app exists"; exit 0; else echo "Error: deployment battle-app not found in ares"; exit 1; fi
