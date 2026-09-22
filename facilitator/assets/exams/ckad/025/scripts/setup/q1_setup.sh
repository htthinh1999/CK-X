#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=starmap
DIR=/home/candidate/exam/q1
CHART="$DIR/orrery"

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
helm -n "$NS" uninstall orrery-south >/dev/null 2>&1 || true
helm -n "$NS" uninstall orrery-north >/dev/null 2>&1 || true

rm -rf "$DIR" && mkdir -p "$DIR"

# Local chart built from the helm scaffold (no repositories needed)
helm create "$CHART" >/dev/null 2>&1 || true
sed -i 's/^  tag: ""/  tag: "1.25"/' "$CHART/values.yaml" 2>/dev/null || true
sed -i 's/^appVersion: .*/appVersion: "1.25"/' "$CHART/Chart.yaml" 2>/dev/null || true
sed -i 's/^description: .*/description: Sky-map frontend for the observatory/' "$CHART/Chart.yaml" 2>/dev/null || true

# Revision 1: working release (nginx:1.25, 2 replicas)
helm -n "$NS" install orrery-north "$CHART" --set replicaCount=2 >/dev/null 2>&1 || true
kubectl -n "$NS" rollout status deployment/orrery-north --timeout=120s >/dev/null 2>&1 || true

# Revision 2: broken upgrade to an image tag that does not exist
helm -n "$NS" upgrade orrery-north "$CHART" --reuse-values --set image.tag=1.25.99 >/dev/null 2>&1 || true

echo "Setup complete for Question 1"
exit 0
