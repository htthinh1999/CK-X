#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace dockhands --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start clean: recreate the six Pods so earlier label/annotation changes are gone.
kubectl -n dockhands delete pod stevedore-1 stevedore-2 stevedore-3 lasher-1 lasher-2 clerk-1 \
  --ignore-not-found --wait=true --timeout=60s >/dev/null 2>&1 || true

kubectl apply -f - <<'YAML' || true
apiVersion: v1
kind: Pod
metadata:
  name: stevedore-1
  namespace: dockhands
  labels:
    role: stevedore
    crew: alpha
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
---
apiVersion: v1
kind: Pod
metadata:
  name: stevedore-2
  namespace: dockhands
  labels:
    role: stevedore
    crew: alpha
    onboarding: pending
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
---
apiVersion: v1
kind: Pod
metadata:
  name: stevedore-3
  namespace: dockhands
  labels:
    role: stevedore
    crew: bravo
    onboarding: pending
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
---
apiVersion: v1
kind: Pod
metadata:
  name: lasher-1
  namespace: dockhands
  labels:
    role: lasher
    crew: alpha
    onboarding: batch-7
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
---
apiVersion: v1
kind: Pod
metadata:
  name: lasher-2
  namespace: dockhands
  labels:
    role: lasher
    crew: bravo
    onboarding: pending
  annotations:
    safety.example.com/certified: expired
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
---
apiVersion: v1
kind: Pod
metadata:
  name: clerk-1
  namespace: dockhands
  labels:
    role: clerk
    shift: day
    onboarding: pending
spec:
  containers:
    - name: main
      image: registry.k8s.io/pause:3.9
YAML

echo "Setup complete for Question 17"
exit 0
