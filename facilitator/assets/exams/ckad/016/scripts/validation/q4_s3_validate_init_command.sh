#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cmd=$(kubectl get pod app-with-wait -n storm -o jsonpath='{.spec.initContainers[0].command}' 2>/dev/null)
if [[ "$cmd" == *"database-svc"* ]]; then echo "Success: init command references database-svc"; exit 0; fi
echo "Error: init container command does not reference database-svc (got: $cmd)"; exit 1
