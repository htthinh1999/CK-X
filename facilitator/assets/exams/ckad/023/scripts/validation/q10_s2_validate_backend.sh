#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
svc=$(kubectl $CTX -n prod get ingress shop-ing -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
port=$(kubectl $CTX -n prod get ingress shop-ing -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
[ "$svc" = "shop-svc" ] && [ "$port" = "80" ] && { echo "OK"; exit 0; }
echo "ERR: backend svc=$svc port=$port"; exit 1
