#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get pod config-aggregator -n hunt -o jsonpath='{.spec.containers[0].volumeMounts[?(@.name=="combined-config")].mountPath}' 2>/dev/null)
if [ "$m" = "/etc/config" ]; then echo "Success: mounted at /etc/config"; exit 0; else echo "Error: mountPath='$m' expected /etc/config"; exit 1; fi
