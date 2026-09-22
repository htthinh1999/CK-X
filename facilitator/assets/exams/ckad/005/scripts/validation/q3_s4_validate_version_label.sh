#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment stable-green -n stripe -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$v" = "green" ]; then echo "Success: version=green label"; exit 0; else echo "Error: version label='$v' expected green"; exit 1; fi
