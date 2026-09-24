#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
tls=$(kubectl get ingress multi-tls-ingress -n lyric -o jsonpath='{.spec.tls}' 2>/dev/null)
if [[ "$tls" == *"app1-tls"* ]] && [[ "$tls" == *"app2-tls"* ]]; then
  echo "Success: ingress TLS references app1-tls and app2-tls"; exit 0
fi
echo "Error: ingress TLS does not reference both secrets"; exit 1
