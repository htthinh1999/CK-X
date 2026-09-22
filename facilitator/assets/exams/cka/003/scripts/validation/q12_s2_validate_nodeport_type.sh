#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
t=$(kubectl $CTX -n beta get svc api-np -o jsonpath='{.spec.type}' 2>/dev/null)
[ "$t" = "NodePort" ] && { echo "OK: NodePort"; exit 0; }
echo "ERR: type=$t, expected NodePort"; exit 1
