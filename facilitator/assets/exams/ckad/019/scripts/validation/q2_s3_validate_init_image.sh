#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(kubectl get pod web-setup -n fortress -o jsonpath='{.spec.initContainers[0].image}' 2>/dev/null)
[ "$img" = "busybox:1.36" ] && { echo "Success: init container image is busybox:1.36"; exit 0; }
echo "Error: init container image is '$img', expected busybox:1.36"; exit 1
