#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod token-pod -n hades -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
if [ "$v" = "/var/run/secrets/tokens" ]; then echo "Success: mount path correct"; exit 0; else echo "Error: mount path is '$v', expected /var/run/secrets/tokens"; exit 1; fi
