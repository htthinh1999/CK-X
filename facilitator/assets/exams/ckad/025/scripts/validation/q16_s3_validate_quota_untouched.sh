#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectro

q=$(kubectl -n "$NS" get resourcequota spectro-budget -o json 2>/dev/null) || { echo "FAIL: ResourceQuota spectro-budget not found in namespace $NS"; exit 1; }

echo "$q" | jq -e '.spec.hard == {"pods":"6","requests.cpu":"400m","requests.memory":"512Mi","limits.cpu":"1","limits.memory":"1Gi"}' >/dev/null \
  || { echo "FAIL: ResourceQuota spectro-budget was changed: $(echo "$q" | jq -c '.spec.hard')"; exit 1; }

d=$(kubectl -n "$NS" get deployment prism -o json 2>/dev/null) || { echo "FAIL: Deployment prism not found in namespace $NS"; exit 1; }
echo "$d" | jq -e 'all(.spec.template.spec.containers[]; (.resources // {}) == {})' >/dev/null \
  || { echo "FAIL: Deployment prism must not set resources itself (defaults must come from the LimitRange)"; exit 1; }

# Only meaningful once the problem is fixed: pods of prism must actually be admitted and Ready
ready=$(echo "$d" | jq -r '.status.readyReplicas // 0')
[ "$ready" -ge 1 ] 2>/dev/null || { echo "FAIL: no Ready pods of prism yet, the quota problem is not fixed"; exit 1; }

echo "OK: quota unchanged and Deployment prism declares no resources"
exit 0
