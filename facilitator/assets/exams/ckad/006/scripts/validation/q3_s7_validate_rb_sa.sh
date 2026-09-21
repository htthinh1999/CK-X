#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get rolebinding log-rb -n marsh -o jsonpath='{.subjects[0].name}' 2>/dev/null)
if [ "$v" = "log-sa" ]; then echo "Success: rolebinding references log-sa"; exit 0; else echo "Error: subject is '$v', expected log-sa"; exit 1; fi
