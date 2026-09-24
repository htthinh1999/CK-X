#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety; DEP=shunter

labels=$(kubectl get namespace "$NS" -o json 2>/dev/null | jq -c '.metadata.labels // {}') || { echo "ERR: namespace $NS not found"; exit 1; }
echo "$labels" | jq -e '.["pod-security.kubernetes.io/enforce"] == "restricted" and .["pod-security.kubernetes.io/enforce-version"] == "latest" and .["pod-security.kubernetes.io/warn"] == "restricted"' >/dev/null 2>&1 \
  || { echo "ERR: the Pod Security labels of namespace $NS were changed: $labels"; exit 1; }

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
# Ask the API server (PodSecurity admission) whether a Pod built from the template is admitted
pod=$(echo "$json" | jq -c --arg ns "$NS" '{apiVersion: "v1", kind: "Pod", metadata: {generateName: "shunter-psa-check-", namespace: $ns, labels: .spec.template.metadata.labels}, spec: .spec.template.spec}')
out=$(echo "$pod" | kubectl create --dry-run=server -f - 2>&1)
if [ $? -ne 0 ]; then
  echo "ERR: a Pod from the $DEP template is rejected: $(echo "$out" | tr '\n' ' ' | cut -c1-400)"
  exit 1
fi

echo "OK: namespace still enforces restricted and the $DEP Pod template is admitted"
exit 0
