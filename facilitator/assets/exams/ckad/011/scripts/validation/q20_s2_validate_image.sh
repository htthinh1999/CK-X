#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
image=$(kubectl get pod pvc-pod -n depths -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
case "$image" in
  *busybox*) echo "Success: image is busybox ($image)"; exit 0 ;;
  *) echo "Error: image is '$image', expected busybox"; exit 1 ;;
esac
