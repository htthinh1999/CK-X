#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

image=$(kubectl get pod init-pod -n crest -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
case "$image" in *nginx*) echo "Success: main image is $image"; exit 0;; *) echo "Error: main image is '$image'"; exit 1;; esac
