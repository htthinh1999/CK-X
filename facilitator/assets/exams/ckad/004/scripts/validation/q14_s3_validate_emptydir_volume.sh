#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod adapter-pod -n zeus -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: shared emptyDir volume exists"; exit 0; else echo "Error: shared emptyDir volume missing"; exit 1; fi
