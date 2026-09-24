#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get svc api-nodeport -n default -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$v" = "9090" ]; then echo "Success: targetPort is 9090"; exit 0; else echo "Error: targetPort is '$v', expected 9090"; exit 1; fi
