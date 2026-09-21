#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get role log-role -n marsh -o jsonpath='{.rules[0].verbs}' 2>/dev/null)
if [[ "$v" == *"get"* ]] && [[ "$v" == *"list"* ]] && [[ "$v" == *"watch"* ]]; then echo "Success: role has get, list, watch verbs"; exit 0; else echo "Error: role verbs are '$v', expected get list watch"; exit 1; fi
