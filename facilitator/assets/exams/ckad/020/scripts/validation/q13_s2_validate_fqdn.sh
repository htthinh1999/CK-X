#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
fqdn_file="/tmp/exam/course/13/fqdn.txt"
if [ ! -f "$fqdn_file" ]; then
  echo "Error: $fqdn_file not found"
  exit 1
fi
content=$(cat "$fqdn_file" 2>/dev/null)
if [[ "$content" == *"data-svc.ancient.svc.cluster.local"* ]]; then
  echo "Success: fqdn.txt contains data-svc.ancient.svc.cluster.local"
  exit 0
fi
echo "Error: fqdn.txt does not contain data-svc.ancient.svc.cluster.local"
exit 1
