#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=kiosk
DIR=/home/candidate/exam/q17

for n in kiosk ops-east ops-west; do
  kubectl create namespace "$n" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
done
# namespace labels (reset on every run)
kubectl label namespace ops-east team=ops --overwrite >/dev/null 2>&1 || true
kubectl label namespace ops-west team=dev --overwrite >/dev/null 2>&1 || true
kubectl label namespace kiosk team- >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete networkpolicy --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n ops-east delete networkpolicy --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n ops-west delete networkpolicy --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete deployment kiosk kiosk-cache --ignore-not-found --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod kiosk-client --ignore-not-found --grace-period=1 --timeout=60s >/dev/null 2>&1 || true
for n in ops-east ops-west; do
  kubectl -n "$n" delete pod monitor guest --ignore-not-found --grace-period=1 --timeout=60s >/dev/null 2>&1 || true
done
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kiosk
  namespace: kiosk
  labels:
    app: kiosk
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kiosk
  template:
    metadata:
      labels:
        app: kiosk
        tier: frontend
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              memory: 64Mi
        - name: metrics
          image: busybox:1.36
          command: ["sh", "-c", "mkdir -p /www && echo kiosk-metrics > /www/index.html && exec httpd -f -p 8081 -h /www"]
          ports:
            - name: metrics
              containerPort: 8081
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
  name: kiosk-cache
  namespace: kiosk
  labels:
    app: kiosk-cache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kiosk-cache
  template:
    metadata:
      labels:
        app: kiosk-cache
        tier: frontend
    spec:
      containers:
        - name: cache
          image: busybox:1.36
          command: ["sh", "-c", "while true; do sleep 3600; done"]
          resources:
            requests:
              cpu: 5m
              memory: 8Mi
            limits:
              memory: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: kiosk-client
  namespace: kiosk
  labels:
    app: kiosk-client
spec:
  containers:
    - name: client
      image: busybox:1.36
      command: ["sh", "-c", "while true; do sleep 3600; done"]
      resources:
        requests:
          cpu: 5m
          memory: 8Mi
        limits:
          memory: 32Mi
---
# left behind by the previous team
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: legacy-frontend
  namespace: kiosk
spec:
  podSelector:
    matchLabels:
      tier: frontend
  policyTypes:
    - Ingress
  ingress:
    - {}
YAML

for n in ops-east ops-west; do
  kubectl -n "$n" apply -f - >/dev/null 2>&1 <<YAML || true
apiVersion: v1
kind: Pod
metadata:
  name: monitor
  namespace: $n
  labels:
    role: monitor
spec:
  containers:
    - name: probe
      image: busybox:1.36
      command: ["sh", "-c", "while true; do sleep 3600; done"]
      resources:
        requests:
          cpu: 5m
          memory: 8Mi
        limits:
          memory: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: guest
  namespace: $n
  labels:
    role: guest
spec:
  containers:
    - name: probe
      image: busybox:1.36
      command: ["sh", "-c", "while true; do sleep 3600; done"]
      resources:
        requests:
          cpu: 5m
          memory: 8Mi
        limits:
          memory: 32Mi
YAML
done

kubectl -n "$NS" rollout status deployment/kiosk --timeout=120s >/dev/null 2>&1 || true
kubectl -n "$NS" wait pod/kiosk-client --for=condition=Ready --timeout=60s >/dev/null 2>&1 || true
for n in ops-east ops-west; do
  kubectl -n "$n" wait pod/monitor pod/guest --for=condition=Ready --timeout=60s >/dev/null 2>&1 || true
done

echo "Setup complete for Question 17"
exit 0
