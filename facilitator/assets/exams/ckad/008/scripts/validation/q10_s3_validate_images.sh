#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

imgs=$(kubectl get pod multi-container -n alpine -o jsonpath='{.spec.containers[*].image}' 2>/dev/null)
case "$imgs" in *busybox*busybox*) echo "Success: both busybox ($imgs)"; exit 0;; *) echo "Error: images are '$imgs'"; exit 1;; esac
