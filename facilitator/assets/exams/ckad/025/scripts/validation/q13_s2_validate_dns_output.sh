#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightwatch
F=/home/candidate/exam/q13/dns.txt

[ -s "$F" ] || { echo "FAIL: $F missing or empty"; exit 1; }

ips=$(kubectl -n "$NS" get pods -l app=watchtower -o json 2>/dev/null \
  | jq -r '.items[] | select(.metadata.deletionTimestamp == null and .status.phase == "Running") | .status.podIP // empty')
count=$(echo $ips | wc -w)
[ "$count" -ge 2 ] || { echo "FAIL: expected 2 running watchtower pods, found $count"; exit 1; }

for ip in $ips; do
  grep -qwF -- "$ip" "$F" || { echo "FAIL: $F does not contain watchtower pod IP $ip"; exit 1; }
done

echo "OK: $F lists all watchtower pod IPs ($(echo $ips))"
exit 0
