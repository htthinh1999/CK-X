#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get service backend-svc -n claw -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$v" = "backend" ]; then echo "Success: selector app=backend"; exit 0; else echo "Error: selector app='$v' expected backend"; exit 1; fi
