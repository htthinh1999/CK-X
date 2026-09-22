#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl -n gatehouse get deployment boom-gate -o json 2>/dev/null \
  | jq -c '.spec.template.spec.containers[] | select(.name == "controller") | .readinessProbe // empty')
[ -n "$p" ] || { echo "FAIL: container controller has no readinessProbe"; exit 1; }
execcmd=$(echo "$p" | jq -r '(.exec.command // []) | join(" ")')
delay=$(echo "$p" | jq -r '.initialDelaySeconds // 0')
period=$(echo "$p" | jq -r '.periodSeconds // 0')
[ -n "$execcmd" ] || { echo "FAIL: readinessProbe is not an exec probe"; exit 1; }
echo "$execcmd" | grep -q '/tmp/gate-open' || { echo "FAIL: exec probe '$execcmd' does not check /tmp/gate-open"; exit 1; }
if [ "$delay" = "5" ] && [ "$period" = "5" ]; then
  echo "OK: exec readinessProbe on /tmp/gate-open, initialDelaySeconds=5, periodSeconds=5"
  exit 0
fi
echo "FAIL: initialDelaySeconds=$delay periodSeconds=$period (expected 5 / 5)"
exit 1
