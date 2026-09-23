#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety; DEP=shunter

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }

# effective settings = container securityContext over pod securityContext
bad=$(echo "$json" | jq -r '
  (.spec.template.spec.securityContext // {}) as $p
  | [(.spec.template.spec.initContainers // [])[], .spec.template.spec.containers[]][]
  | . as $c | (.securityContext // {}) as $sc
  | ($sc.runAsNonRoot // $p.runAsNonRoot) as $nonroot
  | ($sc.runAsUser // $p.runAsUser) as $uid
  | (($sc.seccompProfile // $p.seccompProfile // {}).type // "") as $sec
  | [ (if $nonroot != true then "runAsNonRoot must be true" else empty end),
      (if ($uid == null) then "no runAsUser: busybox runs as root (UID 0) by default, so the kubelet refuses runAsNonRoot" elif ($uid == 0) then "runAsUser is 0" else empty end),
      (if ($sec != "RuntimeDefault" and $sec != "Localhost") then "seccompProfile must be RuntimeDefault" else empty end) ]
  | select(length > 0) | "container \($c.name): \(join("; "))"')
[ -z "$bad" ] || { echo "ERR: $(echo "$bad" | tr '\n' ' ')"; exit 1; }

echo "OK: all containers run as a non-root UID with seccomp RuntimeDefault"
exit 0
