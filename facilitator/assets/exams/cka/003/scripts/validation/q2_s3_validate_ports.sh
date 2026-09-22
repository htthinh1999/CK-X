#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
p=$(kubectl $CTX -n alpha get svc cache-svc -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
tp=$(kubectl $CTX -n alpha get svc cache-svc -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
[ "$p" = "6379" ] && [ "$tp" = "6379" ] && { echo "OK: 6379->6379"; exit 0; }
echo "ERR: port=$p targetPort=$tp, expected 6379/6379"; exit 1
