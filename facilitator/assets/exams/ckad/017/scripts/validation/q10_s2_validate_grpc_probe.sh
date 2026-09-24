#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get pod grpc-checker -n ocean -o jsonpath='{.spec.containers[0].livenessProbe.grpc.port}' 2>/dev/null)
if [ "$p" = "8080" ]; then
  echo "Success: gRPC liveness probe configured on port 8080"; exit 0
fi
echo "Error: gRPC probe port is '$p', expected 8080"; exit 1
