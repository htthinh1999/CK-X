#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pdb critical-pdb -n jungle -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null)
if [ "$v" = "critical-app" ]; then echo "Success: selector app=critical-app"; exit 0; else echo "Error: selector app='$v' expected critical-app"; exit 1; fi
