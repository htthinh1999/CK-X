#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety; DEP=shunter

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
names=$(echo "$json" | jq -r '[(.spec.template.spec.initContainers // [])[].name, .spec.template.spec.containers[].name] | sort | join(",")')
[ "$names" = "prep,shunter" ] || { echo "ERR: expected init container prep and container shunter, found: $names"; exit 1; }

bad=$(echo "$json" | jq -r '
  [(.spec.template.spec.initContainers // [])[], .spec.template.spec.containers[]][]
  | . as $c | (.securityContext // {}) as $sc
  | [ (if $sc.allowPrivilegeEscalation != false then "allowPrivilegeEscalation must be false" else empty end),
      (if (($sc.capabilities.drop // []) | map(ascii_upcase) | index("ALL")) == null then "capabilities.drop must contain ALL" else empty end),
      (if (($sc.capabilities.add // []) | length) > 0 then "must not add capabilities (\($sc.capabilities.add | join(",")))" else empty end),
      (if $sc.privileged == true then "must not be privileged" else empty end) ]
  | select(length > 0) | "container \($c.name): \(join("; "))"')
[ -z "$bad" ] || { echo "ERR: $(echo "$bad" | tr '\n' ' ')"; exit 1; }

echo "OK: prep and shunter disallow privilege escalation and drop ALL capabilities"
exit 0
