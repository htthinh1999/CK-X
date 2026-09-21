#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get secret registry-creds -n hera -o jsonpath='{.type}' 2>/dev/null)
if [ "$v" = "kubernetes.io/dockerconfigjson" ]; then echo "Success: docker-registry secret type"; exit 0; else echo "Error: type is '$v', expected kubernetes.io/dockerconfigjson"; exit 1; fi
