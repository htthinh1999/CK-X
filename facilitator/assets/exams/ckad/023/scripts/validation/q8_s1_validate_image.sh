#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
img=$(kubectl $CTX -n staging get deployment rollme -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:1.25" ] && { echo "OK"; exit 0; }
echo "ERR: image=$img"; exit 1
