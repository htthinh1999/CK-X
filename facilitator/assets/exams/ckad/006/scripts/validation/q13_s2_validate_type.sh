#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get svc api-nodeport -n default -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$v" = "NodePort" ]; then echo "Success: service type is NodePort"; exit 0; else echo "Error: type is '$v', expected NodePort"; exit 1; fi
