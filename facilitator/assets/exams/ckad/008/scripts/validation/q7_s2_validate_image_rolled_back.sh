#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

img=$(kubectl get deployment rollback-deploy -n cave -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$img" != "nginx:1.91" ]; then case "$img" in *nginx*) echo "Success: image is $img"; exit 0;; esac; fi
echo "Error: image is '$img' (expected a valid nginx image, not nginx:1.91)"; exit 1
