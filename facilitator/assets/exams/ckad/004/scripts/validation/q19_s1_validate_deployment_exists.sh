#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment annotated-app -n olympus >/dev/null 2>&1; then echo "Success: deployment annotated-app exists"; exit 0; else echo "Error: deployment annotated-app not found in olympus"; exit 1; fi
