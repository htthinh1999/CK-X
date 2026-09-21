#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

n=$(kubectl get pods -n cave -l app=rollback-deploy --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$n" -ge 1 ]; then echo "Success: $n running pod(s)"; exit 0; else echo "Error: no running pods"; exit 1; fi
