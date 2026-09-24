#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get svc backend-svc -n gate -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$t" = "ClusterIP" ] || [ -z "$t" ]; then echo "Success: Service type ClusterIP ($t)"; exit 0
else echo "Error: Service type is '$t', expected ClusterIP"; exit 1; fi
