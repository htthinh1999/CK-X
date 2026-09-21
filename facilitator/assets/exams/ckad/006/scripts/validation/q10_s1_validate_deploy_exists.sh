#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deploy api-deploy -n rapids >/dev/null 2>&1; then echo "Success: deployment api-deploy exists"; exit 0; else echo "Error: deployment api-deploy not found in rapids"; exit 1; fi
