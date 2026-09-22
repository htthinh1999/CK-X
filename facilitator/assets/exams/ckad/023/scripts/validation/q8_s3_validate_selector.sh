#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
s=$(kubectl $CTX -n staging get svc store-svc -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$s" = "store" ] && { echo "OK"; exit 0; }
echo "ERR: selector app=$s"; exit 1
