#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
t=$(kubectl $CTX -n prod get svc store-svc -o jsonpath='{.spec.type}' 2>/dev/null)
p=$(kubectl $CTX -n prod get svc store-svc -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
[ "$t" = "ClusterIP" ] && [ "$p" = "80" ] && { echo "OK: ClusterIP port 80"; exit 0; }
echo "ERR: type=$t port=$p, expected ClusterIP/80"; exit 1
