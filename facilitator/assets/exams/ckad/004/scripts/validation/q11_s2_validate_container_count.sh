#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
c=$(kubectl get pod adapter-pod -n zeus -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$c" -ge 2 ]; then echo "Success: $c containers"; exit 0; else echo "Error: found $c containers, expected >=2"; exit 1; fi
