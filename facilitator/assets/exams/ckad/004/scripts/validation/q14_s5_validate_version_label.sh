#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment rolling-app -n apollo -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$v" = "v1" ]; then echo "Success: label version=v1"; exit 0; else echo "Error: version label is '$v', expected v1"; exit 1; fi
