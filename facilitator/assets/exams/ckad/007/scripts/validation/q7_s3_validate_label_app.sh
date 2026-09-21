#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-frontend -n coral -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null | grep -q "web-frontend"; then echo "Success: label app web-frontend"; exit 0; else echo "Error: label app web-frontend - not found"; exit 1; fi
