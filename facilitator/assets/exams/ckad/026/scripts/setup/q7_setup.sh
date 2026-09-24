#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=fares
DIR=/home/candidate/exam/q7

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment fare-board --ignore-not-found --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap fare-table fare-table-2025 fare-notes board-style --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod -l app=fare-board --grace-period=1 --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

# Old fare table (what the running Pods will keep showing)
kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: fare-table
  namespace: fares
  labels:
    app: fare-board
data:
  peak.txt: |
    PEAK 3.10
  offpeak.txt: |
    OFFPEAK 2.20
  night.txt: |
    NIGHT 3.80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: fare-table-2025
  namespace: fares
  labels:
    app: fare-board
    archived: "true"
data:
  peak.txt: |
    PEAK 2.95
  offpeak.txt: |
    OFFPEAK 2.05
  night.txt: |
    NIGHT 3.50
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: fare-notes
  namespace: fares
data:
  notes.txt: |
    Fares are reviewed every quarter by the tariff office.
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: board-style
  namespace: fares
data:
  board.css: |
    body { font-family: monospace; background: #002b36; color: #fdf6e3; }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fare-board
  namespace: fares
  labels:
    app: fare-board
spec:
  replicas: 2
  selector:
    matchLabels:
      app: fare-board
  template:
    metadata:
      labels:
        app: fare-board
    spec:
      containers:
        - name: board
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 80
          volumeMounts:
            - name: fares
              mountPath: /usr/share/nginx/html/fares/current.txt
              subPath: peak.txt
            - name: fares
              mountPath: /usr/share/nginx/html/fares/offpeak.txt
              subPath: offpeak.txt
            - name: style
              mountPath: /usr/share/nginx/html/style
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              memory: 64Mi
      volumes:
        - name: fares
          configMap:
            name: fare-table
        - name: style
          configMap:
            name: board-style
YAML

kubectl -n "$NS" rollout status deployment/fare-board --timeout=120s >/dev/null 2>&1 || true
kubectl -n "$NS" wait pod -l app=fare-board --for=condition=Ready --timeout=60s >/dev/null 2>&1 || true
sleep 2

# The tariff office has published new fares since the Pods started
kubectl -n "$NS" create configmap fare-table \
  --from-literal=peak.txt=$'PEAK 3.60\n' \
  --from-literal=offpeak.txt=$'OFFPEAK 2.40\n' \
  --from-literal=night.txt=$'NIGHT 4.00\n' \
  --dry-run=client -o yaml \
  | kubectl label --local -f - app=fare-board -o yaml \
  | kubectl -n "$NS" apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 7"
exit 0
