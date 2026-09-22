#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment annotated-app -n olympus -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: deployment annotation present"; exit 0; else echo "Error: deployment change-cause annotation missing"; exit 1; fi
