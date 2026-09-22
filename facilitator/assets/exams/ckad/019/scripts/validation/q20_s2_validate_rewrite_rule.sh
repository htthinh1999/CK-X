#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/20/coredns.yaml ] && grep -qF "rewrite name exact hachiman.local hachiman.garrison.svc.cluster.local" /tmp/exam/course/20/coredns.yaml; then
  echo "Success: rewrite rule present"; exit 0
fi
echo "Error: rewrite rule not found in coredns.yaml"; exit 1
