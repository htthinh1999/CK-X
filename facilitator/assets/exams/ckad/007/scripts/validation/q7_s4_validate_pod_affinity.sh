#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-frontend -n coral -o jsonpath='{.spec.template.spec.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution}' 2>/dev/null | grep -q "weight"; then echo "Success: podAffinity preferred weight"; exit 0; else echo "Error: podAffinity preferred weight - not found"; exit 1; fi
