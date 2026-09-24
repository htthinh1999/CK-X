#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get cronjob cleanup-job -n stronghold -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
case "$img" in
  *busybox*) echo "Success: image is $img"; exit 0;;
  *) echo "Error: image is '$img', expected busybox:1.36"; exit 1;;
esac
