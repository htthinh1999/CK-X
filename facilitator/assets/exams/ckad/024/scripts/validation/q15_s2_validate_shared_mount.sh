#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n winch get deployment hoist-controller -o json 2>/dev/null) || { echo "ERR: deployment hoist-controller not found in winch"; exit 1; }
r=$(echo "$j" | jq -r '
  .spec.template.spec as $s
  | ([$s.volumes[]? | select(.name == "hoist-logs" and .emptyDir != null)] | length) as $vol
  | ([$s.containers[] | select(.name == "hoist") | .volumeMounts[]? | select(.name == "hoist-logs")] | length) as $app
  | ([$s.containers[] | select(.name == "log-tail") | .volumeMounts[]? | select(.name == "hoist-logs" and ((.mountPath | rtrimstr("/")) == "/var/log/hoist"))] | length) as $side
  | "\($vol) \($app) \($side)"')
[ "$r" = "1 1 1" ] && { echo "OK: hoist and log-tail share the hoist-logs emptyDir"; exit 0; }
echo "ERR: emptyDir hoist-logs / hoist mount / log-tail mount at /var/log/hoist counts = '$r' (want 1 1 1)"; exit 1
