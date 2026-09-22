#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=survey
DIR=/home/candidate/exam/q4

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

# Fresh pods so the creation order below is authoritative (no-op on first run)
kubectl -n "$NS" delete pod --all --grace-period=1 --wait=true --timeout=60s >/dev/null 2>&1 || true

# Created one per second, deliberately NOT in alphabetical order
kubectl -n "$NS" run quasar   --image=nginx:1.25 --labels=role=receiver >/dev/null 2>&1 || true
sleep 1
kubectl -n "$NS" run aurora   --image=busybox:1.36 --labels=role=logger --command -- sleep 86400 >/dev/null 2>&1 || true
sleep 1
kubectl -n "$NS" run nebula   --image=redis:7-alpine --labels=role=cache >/dev/null 2>&1 || true
sleep 1
kubectl -n "$NS" run borealis --image=registry.k8s.io/pause:3.9 --labels=role=placeholder >/dev/null 2>&1 || true
sleep 1
kubectl -n "$NS" run meridian --image=nginx:1.25 --labels=role=receiver >/dev/null 2>&1 || true

echo "Setup complete for Question 4"
exit 0
