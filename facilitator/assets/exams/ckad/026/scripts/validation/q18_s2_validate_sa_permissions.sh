#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=freight
AS=system:serviceaccount:freight:freight-reader

kubectl -n "$NS" get serviceaccount freight-reader >/dev/null 2>&1 || { echo "ERR: ServiceAccount freight-reader not found"; exit 1; }

can() { kubectl auth can-i "$@" --as="$AS" 2>/dev/null | head -1 | awk '{print $1}'; }

while read -r verb res ns; do
  [ "$(can "$verb" "$res" -n "$ns")" = "yes" ] || { echo "ERR: freight-reader cannot '$verb $res' in $ns but must"; exit 1; }
done <<'LIST'
get configmaps freight
list configmaps freight
watch configmaps freight
get configmaps/freight-routes freight
get secrets/route-key freight
LIST

while read -r verb res ns; do
  [ "$(can "$verb" "$res" -n "$ns")" = "no" ] || { echo "ERR: freight-reader is allowed to '$verb $res' in $ns (more than required)"; exit 1; }
done <<'LIST'
list secrets freight
watch secrets freight
get secrets/tariff-db freight
get secrets/route-key-backup freight
update secrets/route-key freight
delete secrets/route-key freight
create configmaps freight
update configmaps/freight-routes freight
patch configmaps/freight-routes freight
delete configmaps/freight-routes freight
get pods freight
list pods freight
create pods freight
get deployments.apps freight
update deployments.apps/freight-api freight
get configmaps default
get secrets/route-key default
LIST

echo "OK: freight-reader can read ConfigMaps and only the Secret route-key, nothing more"
exit 0
