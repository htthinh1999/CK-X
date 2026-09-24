#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightwatch
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q2 && mkdir -p /home/candidate/exam/q2

# Reset objects the student creates / the crash history of the pod
kubectl -n "$NS" delete service watchtower-peers --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod insomniac --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: watchtower
  namespace: nightwatch
  labels:
    app: watchtower
spec:
  replicas: 2
  selector:
    matchLabels:
      app: watchtower
  template:
    metadata:
      labels:
        app: watchtower
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 100m
              memory: 128Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: insomniac
  namespace: nightwatch
  labels:
    app: insomniac
spec:
  volumes:
    - name: state
      emptyDir: {}
  containers:
    - name: monitor
      image: busybox:1.36
      command: ["sh", "-c"]
      args:
        - |
          if [ -f /state/crashed ]; then
            echo "night-shift monitor restarted - standing by"
            while true; do sleep 3600; done
          fi
          touch /state/crashed
          echo "night-shift monitor booting on $(hostname)"
          echo "FATAL: guide-star lock lost (token=$(date +%s))"
          exit 1
      volumeMounts:
        - name: state
          mountPath: /state
      resources:
        requests:
          cpu: 5m
          memory: 8Mi
        limits:
          cpu: 50m
          memory: 32Mi
YAML

kubectl -n "$NS" rollout status deployment/watchtower --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 2"
exit 0
