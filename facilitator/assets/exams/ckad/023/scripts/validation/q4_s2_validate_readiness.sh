#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
p=$(kubectl $CTX -n dev get pod probed -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null)
[ -n "$p" ] && { echo "OK: readiness httpGet $p"; exit 0; }
echo "ERR: no httpGet readinessProbe on pod probed"; exit 1
