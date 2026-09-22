#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
pt=$(kubectl $CTX -n beta get networkpolicy default-deny -o jsonpath='{.spec.policyTypes[*]}' 2>/dev/null)
echo "$pt" | grep -q "Ingress" && { echo "OK: policyTypes has Ingress"; exit 0; }
echo "ERR: policyTypes='$pt', expected to include Ingress"; exit 1
