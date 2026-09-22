#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n dockhands get pods -o json 2>/dev/null) || { echo "ERR: cannot list pods in dockhands"; exit 1; }
r=$(echo "$j" | jq -r '
  [.items[] | select(.metadata.labels.role == "lasher")] as $l
  | [.items[] | select(.metadata.labels.role != "lasher")] as $o
  | "\($l | length) \([$l[] | select(.metadata.annotations["safety.example.com/certified"] == "rigging-l2")] | length) \([$o[] | select(.metadata.annotations["safety.example.com/certified"] != null)] | length)"')
[ "$r" = "2 2 0" ] && { echo "OK: both lasher pods (and only those) carry safety.example.com/certified=rigging-l2"; exit 0; }
echo "ERR: lasher pods / correctly annotated / other pods with the annotation = '$r' (want 2 2 0)"; exit 1
