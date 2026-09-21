#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

c=$(kubectl get pod multi-container -n alpine -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$c" -eq 2 ]; then echo "Success: 2 containers"; exit 0; else echo "Error: $c containers (expected 2)"; exit 1; fi
