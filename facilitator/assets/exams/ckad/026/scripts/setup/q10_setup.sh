#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety
DIR=/home/candidate/exam/q10

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment --all --ignore-not-found --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod --all --grace-period=1 --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

# The namespace enforces the restricted Pod Security Standard
kubectl label namespace "$NS" --overwrite \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=latest \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/warn-version=latest >/dev/null 2>&1 || true
kubectl label namespace "$NS" pod-security.kubernetes.io/audit- >/dev/null 2>&1 || true

# A compliant neighbour: the pause image already runs as a non-root user (65535)
kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: yard-beacon
  namespace: yardsafety
  labels:
    app: yard-beacon
spec:
  replicas: 1
  selector:
    matchLabels:
      app: yard-beacon
  template:
    metadata:
      labels:
        app: yard-beacon
    spec:
      securityContext:
        runAsNonRoot: true
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: beacon
          image: registry.k8s.io/pause:3.9
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 16Mi
YAML

# The broken Deployment (applied without the PSA warnings being shown)
kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: shunter
  namespace: yardsafety
  labels:
    app: shunter
spec:
  replicas: 2
  selector:
    matchLabels:
      app: shunter
  template:
    metadata:
      labels:
        app: shunter
    spec:
      initContainers:
        - name: prep
          image: busybox:1.36
          command: ["sh", "-c", "echo 'plan: siding-4 -> platform-2' > /scratch/plan.txt"]
          volumeMounts:
            - name: scratch
              mountPath: /scratch
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
      containers:
        - name: shunter
          image: busybox:1.36
          command: ["sh", "-c", "cat /scratch/plan.txt; while true; do date >> /scratch/moves.log; sleep 30; done"]
          securityContext:
            capabilities:
              add: ["NET_ADMIN"]
          volumeMounts:
            - name: scratch
              mountPath: /scratch
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
      volumes:
        - name: scratch
          hostPath:
            path: /tmp/shunter
            type: DirectoryOrCreate
YAML

echo "Setup complete for Question 10"
exit 0
