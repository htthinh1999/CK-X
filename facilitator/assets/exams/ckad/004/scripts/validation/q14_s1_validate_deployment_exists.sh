#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment rolling-app -n apollo >/dev/null 2>&1; then echo "Success: deployment rolling-app exists"; exit 0; else echo "Error: deployment rolling-app not found in apollo"; exit 1; fi
