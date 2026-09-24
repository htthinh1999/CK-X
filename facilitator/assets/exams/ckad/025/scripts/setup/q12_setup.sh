#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace catalog --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

D=/home/candidate/exam/q12
rm -rf "$D"
mkdir -p "$D"

# Server-side apply: no last-applied-configuration annotation is added, so the
# only annotations on the Pods are the ones below.
kubectl apply --server-side --force-conflicts -f - <<'YAML' || true
apiVersion: v1
kind: Pod
metadata:
  name: idx-andromeda
  namespace: catalog
  labels:
    app: indexer
    tier: ingest
    survey: deep
  annotations:
    catalog.observatory.io/legacy-schema: "v1"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
---
apiVersion: v1
kind: Pod
metadata:
  name: idx-bootes
  namespace: catalog
  labels:
    app: indexer
    tier: ingest
    survey: wide
  annotations:
    catalog.observatory.io/legacy-schema-migrated: "2026-08-14"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
---
apiVersion: v1
kind: Pod
metadata:
  name: idx-cygnus
  namespace: catalog
  labels:
    app: indexer
    tier: query
    survey: deep
  annotations:
    catalog.observatory.io/owner: "stellar-cartography"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
---
apiVersion: v1
kind: Pod
metadata:
  name: idx-draco
  namespace: catalog
  labels:
    app: indexer
    tier: query
    survey: wide
  annotations:
    catalog.observatory.io/legacy-schema: "v2"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
---
apiVersion: v1
kind: Pod
metadata:
  name: idx-eridanus
  namespace: catalog
  labels:
    app: indexer
    tier: archive
    survey: deep
  annotations:
    catalog.observatory.io/legacy-schema: "v1"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
---
apiVersion: v1
kind: Pod
metadata:
  name: idx-fornax
  namespace: catalog
  labels:
    app: indexer
    tier: archive
    survey: wide
  annotations:
    catalog.observatory.io/owner: "deep-field"
spec:
  containers:
    - name: idx
      image: registry.k8s.io/pause:3.9
      resources:
        requests: {cpu: 5m, memory: 8Mi}
        limits: {cpu: 20m, memory: 16Mi}
YAML

echo "Setup complete for Question 12"
exit 0
