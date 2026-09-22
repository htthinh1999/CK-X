#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

n=$(kubectl get pod init-pod -n crest -o jsonpath='{.spec.initContainers[0].name}' 2>/dev/null)
if [ -n "$n" ]; then echo "Success: init container is $n"; exit 0; else echo "Error: no init container"; exit 1; fi
