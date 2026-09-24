#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=catalog

json=$(kubectl -n "$NS" get pods -o json 2>/dev/null) || { echo "FAIL: cannot list pods in $NS"; exit 1; }

check() { # pod expected-tier
  got=$(echo "$json" | jq -r --arg p "$1" '[.items[] | select(.metadata.name==$p) | (.metadata.labels.tier // "<none>")][0] // "<missing pod>"')
  [ "$got" = "$2" ] || { echo "FAIL: pod $1 should have tier=$2, got $got"; exit 1; }
}
check idx-andromeda stream
check idx-bootes    stream
check idx-cygnus    query
check idx-draco     query
check idx-eridanus  archive
check idx-fornax    archive

left=$(echo "$json" | jq '[.items[] | select(.metadata.labels.tier=="ingest")] | length')
[ "$left" = "0" ] || { echo "FAIL: $left pod(s) still labelled tier=ingest"; exit 1; }

echo "PASS: former tier=ingest pods are now tier=stream, others unchanged"
exit 0
