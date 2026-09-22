#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
D=/home/candidate/exam/q3/overlays/canary
K=""
for f in kustomization.yaml kustomization.yml Kustomization; do
  [ -f "$D/$f" ] && { K="$D/$f"; break; }
done
[ -n "$K" ] || { echo "FAIL: no kustomization file in $D"; exit 1; }
grep -Eq '\.\./\.\./base/?' "$K" || { echo "FAIL: overlay does not use ../../base"; exit 1; }

out=$(kubectl kustomize "$D" 2>/dev/null) || { echo "FAIL: kubectl kustomize $D fails"; exit 1; }
kinds=$(echo "$out" | grep -E '^kind:' | tr -d '[:space:]')
[ "$kinds" = "kind:Deployment" ] || { echo "FAIL: overlay must render exactly one Deployment, got: $(echo "$out" | grep -E '^kind:' | tr '\n' ' ')"; exit 1; }
echo "$out" | grep -Eq '^  name: weighbridge-canary[[:space:]]*$' || { echo "FAIL: rendered Deployment is not named weighbridge-canary"; exit 1; }
echo "$out" | grep -Eq 'image: "?nginx:1\.26"?[[:space:]]*$' || { echo "FAIL: rendered Deployment does not use nginx:1.26"; exit 1; }

# The base must still render the stable Deployment unchanged (3 x nginx:1.25).
base=$(kubectl kustomize /home/candidate/exam/q3/base 2>/dev/null)
if echo "$base" | grep -Eq '^  replicas: 3[[:space:]]*$' && echo "$base" | grep -Eq 'image: "?nginx:1\.25"?[[:space:]]*$'; then
  echo "OK: canary overlay renders only Deployment weighbridge-canary; base intact"
  exit 0
fi
echo "FAIL: base no longer renders 3 replicas of nginx:1.25 (base must not be modified)"
exit 1
