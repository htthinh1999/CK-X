#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get role pod-reader-role -n bastion -o jsonpath='{.rules[0].verbs}' 2>/dev/null)
if echo "$v" | grep -q "list" && echo "$v" | grep -q "get"; then echo "Success: Role verbs include get,list ($v)"; exit 0
else echo "Error: Role verbs incorrect ($v)"; exit 1; fi
