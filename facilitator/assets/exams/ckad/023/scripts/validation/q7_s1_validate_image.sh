#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
img=$(kubectl $CTX -n dev get deployment rollme -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:1.25" ] && { echo "OK: image nginx:1.25"; exit 0; }
echo "ERR: image=$img, expected nginx:1.25"; exit 1
