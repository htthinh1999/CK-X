#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
rr=$(kubectl $CTX -n alpha get rolebinding deployer-binding -o jsonpath='{.roleRef.name}' 2>/dev/null)
sub=$(kubectl $CTX -n alpha get rolebinding deployer-binding -o jsonpath='{.subjects[*].name}' 2>/dev/null)
[ "$rr" = "deployer-role" ] && echo "$sub" | grep -q "deployer" && { echo "OK: rolebinding correct"; exit 0; }
echo "ERR: rolebinding deployer-binding roleRef=$rr subjects=$sub"; exit 1
