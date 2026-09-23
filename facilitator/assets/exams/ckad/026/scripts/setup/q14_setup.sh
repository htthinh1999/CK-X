#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=sleepers
DIR=/home/candidate/exam/q14

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment --all --ignore-not-found --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod --all --grace-period=1 --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleeper-lounge
  namespace: sleepers
  labels:
    app: sleeper-lounge
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleeper-lounge
  template:
    metadata:
      labels:
        app: sleeper-lounge
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 80
          livenessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              memory: 64Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleeper-bar
  namespace: sleepers
  labels:
    app: sleeper-bar
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleeper-bar
  template:
    metadata:
      labels:
        app: sleeper-bar
    spec:
      terminationGracePeriodSeconds: 5
      containers:
        - name: bar
          image: nginx:1.25
          command: ["sh", "-c", "echo 'stocking the bar (10s)'; sleep 10 & wait $!; exec nginx -g 'daemon off;'"]
          ports:
            - name: http
              containerPort: 80
          startupProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
            failureThreshold: 6
          livenessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 10
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              memory: 64Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleeper-linen
  namespace: sleepers
  labels:
    app: sleeper-linen
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleeper-linen
  template:
    metadata:
      labels:
        app: sleeper-linen
    spec:
      containers:
        - name: linen
          image: busybox:1.36
          command: ["sh", "-c", "echo 'reading /etc/linen/stock.csv'; sleep 5; echo 'ERROR: stock file not found' >&2; exit 3"]
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleeper-wakeup
  namespace: sleepers
  labels:
    app: sleeper-wakeup
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleeper-wakeup
  template:
    metadata:
      labels:
        app: sleeper-wakeup
    spec:
      containers:
        - name: alarm
          image: busybox:1.36
          command: ["sh", "-c", "touch /tmp/alive; while true; do date; sleep 60; done"]
          livenessProbe:
            exec:
              command: ["test", "-f", "/tmp/alive"]
            periodSeconds: 15
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleeper-berths
  namespace: sleepers
  labels:
    app: sleeper-berths
spec:
  replicas: 2
  selector:
    matchLabels:
      app: sleeper-berths
  template:
    metadata:
      labels:
        app: sleeper-berths
    spec:
      terminationGracePeriodSeconds: 5
      containers:
        - name: log-tail
          image: busybox:1.36
          command: ["sh", "-c", "while true; do sleep 3600; done"]
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
        - name: warmer
          image: nginx:1.25
          command: ["sh", "-c", "echo 'loading berth allocation map, this takes about 40s'; sleep 40 & wait $!; echo 'map loaded'; exec nginx -g 'daemon off;'"]
          ports:
            - name: http
              containerPort: 80
          livenessProbe:
            httpGet:
              path: /
              port: http
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 1
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              memory: 64Mi
YAML

kubectl -n "$NS" rollout status deployment/sleeper-lounge --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 14"
exit 0
