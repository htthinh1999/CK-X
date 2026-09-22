#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get svc api-nodeport -n default -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$v" = "80" ]; then echo "Success: service port is 80"; exit 0; else echo "Error: port is '$v', expected 80"; exit 1; fi
