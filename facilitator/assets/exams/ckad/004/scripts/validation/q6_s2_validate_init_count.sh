#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get pod multi-init -n poseidon -o jsonpath='{.spec.initContainers[*].name}' 2>/dev/null | wc -w)
if [ "$c" -ge 2 ]; then echo "Success: $c init containers"; exit 0; else echo "Error: found $c init containers, expected >=2"; exit 1; fi
