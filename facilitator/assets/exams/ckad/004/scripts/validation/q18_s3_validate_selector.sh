#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pdb app-pdb -n hera -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null)
if [ "$v" = "critical" ]; then echo "Success: selector app=critical"; exit 0; else echo "Error: selector app is '$v', expected critical"; exit 1; fi
