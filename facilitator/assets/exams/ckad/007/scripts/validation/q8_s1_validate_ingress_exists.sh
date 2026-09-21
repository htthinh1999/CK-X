#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress api-routing -n lagoon >/dev/null 2>&1; then echo "Success: ingress api-routing exists in lagoon"; exit 0; else echo "Error: ingress api-routing not found in lagoon"; exit 1; fi
