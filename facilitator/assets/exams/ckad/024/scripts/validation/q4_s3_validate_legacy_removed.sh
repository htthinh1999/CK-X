#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
list=$(helm list -n berth -a -o json 2>/dev/null)
[ -z "$list" ] && { echo "FAIL: cannot list helm releases in namespace berth"; exit 1; }
# Absent, or kept only as history (--keep-history -> status "uninstalled").
st=$(echo "$list" | jq -r '.[] | select(.name=="pilot-legacy") | .status')
if [ -n "$st" ] && [ "$st" != "uninstalled" ]; then
  echo "FAIL: release pilot-legacy still exists (status=$st)"
  exit 1
fi
left=$(kubectl -n berth get deployment,service -l app.kubernetes.io/instance=pilot-legacy -o name 2>/dev/null)
if [ -z "$left" ]; then
  echo "OK: release pilot-legacy uninstalled"
  exit 0
fi
echo "FAIL: resources of pilot-legacy still exist: $left"
exit 1
