#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get job cleanup-job -n stripe -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$v" = "cleanup" ]; then echo "Success: container named cleanup"; exit 0; else echo "Error: container='$v' expected cleanup"; exit 1; fi
