#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
if kubectl $CTX -n alpha get deployment web >/dev/null 2>&1; then echo "OK: deployment web exists"; exit 0; fi
echo "ERR: deployment web not found in alpha"; exit 1
