#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q5/phase.sh
[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }

# Exactly one command line (a shebang / comment lines are tolerated).
lines=$(grep -v '^[[:space:]]*#' "$F" | grep -c '[^[:space:]]')
[ "$lines" -eq 1 ] || { echo "FAIL: expected one command line in $F, found $lines"; exit 1; }
cmd=$(grep -v '^[[:space:]]*#' "$F" | grep '[^[:space:]]')
echo "$cmd" | grep -q 'kubectl' || { echo "FAIL: command does not use kubectl"; exit 1; }
echo "$cmd" | grep -q 'jsonpath' || { echo "FAIL: command does not use jsonpath output"; exit 1; }
echo "$cmd" | grep -q 'lamp-keeper' || { echo "FAIL: command does not reference pod lamp-keeper"; exit 1; }

# Run it from a neutral directory with a private kubeconfig copy whose current
# namespace is 'default', so it must not rely on the current namespace.
RUNKC="$KUBECONFIG"
tmpkc=$(mktemp 2>/dev/null)
if [ -n "$tmpkc" ] && cp "$KUBECONFIG" "$tmpkc" 2>/dev/null \
   && KUBECONFIG="$tmpkc" kubectl config set-context --current --namespace=default >/dev/null 2>&1 \
   && KUBECONFIG="$tmpkc" kubectl get namespace beacon >/dev/null 2>&1; then
  RUNKC="$tmpkc"
fi
out=$(cd /tmp && KUBECONFIG="$RUNKC" timeout 20 bash "$F" 2>/dev/null)
[ -n "$tmpkc" ] && rm -f "$tmpkc"

got=$(printf '%s' "$out" | tr -d '[:space:]')
if [ "$got" = "Running" ]; then
  echo "OK: phase.sh prints 'Running'"
  exit 0
fi
echo "FAIL: phase.sh printed '$out' (expected only: Running)"
exit 1
