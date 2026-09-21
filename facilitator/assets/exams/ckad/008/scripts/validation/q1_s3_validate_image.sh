#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

image=$(kubectl get pod nginx -n mynamespace -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
case "$image" in *nginx*) echo "Success: image is $image"; exit 0;; *) echo "Error: image is '$image'"; exit 1;; esac
