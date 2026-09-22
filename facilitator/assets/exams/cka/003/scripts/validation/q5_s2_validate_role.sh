#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
res=$(kubectl $CTX -n alpha get role deployer-role -o jsonpath='{.rules[*].resources}' 2>/dev/null)
vrb=$(kubectl $CTX -n alpha get role deployer-role -o jsonpath='{.rules[*].verbs}' 2>/dev/null)
echo "$res" | grep -q "deployments" && echo "$vrb" | grep -q "get" && echo "$vrb" | grep -q "list" && echo "$vrb" | grep -q "create" \
  && { echo "OK: role rules correct"; exit 0; }
echo "ERR: role deployer-role missing deployments get/list/create (res=$res verbs=$vrb)"; exit 1
