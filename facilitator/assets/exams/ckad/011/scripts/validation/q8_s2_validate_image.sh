#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
image=$(kubectl get pod direct-pod -n coral -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
case "$image" in
  *nginx*) echo "Success: image is nginx ($image)"; exit 0 ;;
  *) echo "Error: image is '$image', expected nginx"; exit 1 ;;
esac
