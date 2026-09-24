#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pod init-pod -n crest -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ "$v" = "{}" ]; then echo "Success: emptyDir volume present"; exit 0; else echo "Error: emptyDir volume not found (got '$v')"; exit 1; fi
