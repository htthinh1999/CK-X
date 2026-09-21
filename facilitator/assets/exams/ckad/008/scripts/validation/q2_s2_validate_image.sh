#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

image=$(kubectl get pod envpod -n summit -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
case "$image" in *busybox*) echo "Success: image is $image"; exit 0;; *) echo "Error: image is '$image'"; exit 1;; esac
