#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
D=/home/candidate/exam/q17/telemetry

[ -f "$D/kustomization.yaml" ] || { echo "FAIL: $D/kustomization.yaml not found"; exit 1; }
grep -Eq '^images:' "$D/kustomization.yaml" || { echo "FAIL: kustomization.yaml has no images: entry"; exit 1; }
grep -Eq 'image:[[:space:]]*"?nginx:1\.25"?[[:space:]]*$' "$D/deployment.yaml" 2>/dev/null \
  || { echo "FAIL: deployment.yaml must not be edited (it must still say nginx:1.25)"; exit 1; }

out=$(kubectl kustomize "$D" 2>/dev/null) || { echo "FAIL: kubectl kustomize $D does not build"; exit 1; }
echo "$out" | grep -Eq 'image:[[:space:]]*"?nginx:1\.26"?[[:space:]]*$' || { echo "FAIL: rendered output does not use nginx:1.26"; exit 1; }
echo "$out" | grep -q 'nginx:1\.25' && { echo "FAIL: rendered output still contains nginx:1.25"; exit 1; }

echo "PASS: kustomization images entry renders nginx:1.26 without editing deployment.yaml"
exit 0
