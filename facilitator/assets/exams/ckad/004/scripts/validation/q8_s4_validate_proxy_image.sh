#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod ambassador-pod -n olympus -o jsonpath='{.spec.containers[?(@.name=="proxy")].image}' 2>/dev/null)
case "$v" in *envoy*) echo "Success: proxy uses envoy image ($v)"; exit 0;; *) echo "Error: proxy image is '$v', expected to contain envoy"; exit 1;; esac
