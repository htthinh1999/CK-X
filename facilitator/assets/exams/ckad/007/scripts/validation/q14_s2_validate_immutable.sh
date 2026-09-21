#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get secret app-credentials -n deep -o jsonpath='{.immutable}' 2>/dev/null)
if [ "$val" = "true" ]; then echo "Success: immutable is true"; exit 0; else echo "Error: immutable is '$val', expected true"; exit 1; fi
