#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress multi-tls-ingress -n lyric >/dev/null 2>&1; then
  echo "Success: ingress multi-tls-ingress exists"; exit 0
fi
echo "Error: ingress multi-tls-ingress not found in lyric"; exit 1
