#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
# an emptyDir volume mounted by at least two of: app containers + native sidecars (init containers with restartPolicy Always)
vol=$(kubectl $CTX -n dev get pod sidecar-pod -o json 2>/dev/null | jq -r '
  [.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] as $c
  | [.spec.volumes[]? | select(.emptyDir) | .name as $v
     | select([$c[] | select(any(.volumeMounts[]?; .name == $v))] | length >= 2) | $v] | first // empty')
[ -n "$vol" ] && { echo "OK: shared emptyDir '$vol'"; exit 0; }
echo "ERR: no emptyDir mounted in both containers"; exit 1
