#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
st=$(helm status battle-web -n garrison -o json 2>/dev/null | grep -i deployed)
[ -n "$st" ] && { echo "Success: helm release battle-web is deployed"; exit 0; }
echo "Error: helm release battle-web not deployed"; exit 1
