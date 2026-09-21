#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get role pod-reader-role -n bastion -o jsonpath='{.rules[0].resources}' 2>/dev/null)
case "$r" in
  *pods*) echo "Success: Role resources include pods ($r)"; exit 0;;
  *) echo "Error: Role resources incorrect ($r)"; exit 1;;
esac
