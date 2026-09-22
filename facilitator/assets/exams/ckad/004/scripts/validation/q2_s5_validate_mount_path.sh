#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod config-reader -n athena -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
if [ "$v" = "/etc/config" ]; then echo "Success: mounted at /etc/config"; exit 0; else echo "Error: mount path is '$v', expected /etc/config"; exit 1; fi
