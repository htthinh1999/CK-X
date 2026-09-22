#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
p=$(kubectl $CTX -n dev get pod probed -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null)
[ -n "$p" ] && { echo "OK: liveness httpGet $p"; exit 0; }
echo "ERR: no httpGet livenessProbe on pod probed"; exit 1
