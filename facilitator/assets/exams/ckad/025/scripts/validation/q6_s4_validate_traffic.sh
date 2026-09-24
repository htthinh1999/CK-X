#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=relay

kubectl -n "$NS" get networkpolicy collector-egress >/dev/null 2>&1 || { echo "ERR: NetworkPolicy collector-egress not found"; exit 1; }
pod=$(kubectl -n "$NS" get pods -l app=collector --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$pod" ] || { echo "ERR: no running collector pod"; exit 1; }

# Allowed: DNS lookup + TCP 6379 to archive
if ! timeout 15 kubectl -n "$NS" exec "$pod" -- nc -z -w 3 archive 6379 >/dev/null 2>&1; then
  echo "ERR: $pod cannot reach archive:6379 (check the archive and DNS rules)"
  exit 1
fi
# Denied: anything else, e.g. webcache:80
if timeout 15 kubectl -n "$NS" exec "$pod" -- nc -z -w 3 webcache 80 >/dev/null 2>&1; then
  echo "ERR: $pod can still reach webcache:80, other egress is not denied"
  exit 1
fi

echo "OK: collector reaches archive:6379 and is blocked from webcache:80"
exit 0
