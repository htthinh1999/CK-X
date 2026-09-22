#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=almanac

left=$(kubectl -n "$NS" get configmap -l stale=true -o name 2>/dev/null | sed '/^$/d')
[ -z "$left" ] || { echo "ERR: ConfigMaps labelled stale=true still exist: $(echo $left)"; exit 1; }

for cm in ephemeris-2025 observer-roster; do
  kubectl -n "$NS" get configmap "$cm" >/dev/null 2>&1 || { echo "ERR: ConfigMap $cm should not have been deleted"; exit 1; }
done

echo "OK: stale=true ConfigMaps removed, others kept"
exit 0
