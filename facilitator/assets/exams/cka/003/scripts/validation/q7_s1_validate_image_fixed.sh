#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
img=$(kubectl $CTX -n alpha get deployment legacy -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
echo "$img" | grep -q "nginx" && ! echo "$img" | grep -q "nope" && { echo "OK: image fixed to $img"; exit 0; }
echo "ERR: image is still '$img'"; exit 1
