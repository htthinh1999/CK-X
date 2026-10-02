#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# proxy may be a regular container or a native sidecar (init container with restartPolicy Always)
v=$(kubectl get pod ambassador-pod -n olympus -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | .[] | select(.name == "proxy") | .image')
case "$v" in *envoy*) echo "Success: proxy uses envoy image ($v)"; exit 0;; *) echo "Error: proxy image is '$v', expected to contain envoy"; exit 1;; esac
