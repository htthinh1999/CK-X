#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace orbit --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

D=/home/candidate/exam/q12
rm -rf "$D"
mkdir -p "$D/telemetry"

cat > "$D/telemetry/deployment.yaml" <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: telemetry
  labels:
    app: telemetry
    track: stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: telemetry
      track: stable
  template:
    metadata:
      labels:
        app: telemetry
        track: stable
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
              cpu: 50m
              memory: 64Mi
YAML

cat > "$D/telemetry/service.yaml" <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: telemetry
  labels:
    app: telemetry
spec:
  selector:
    app: telemetry
  ports:
    - name: http
      port: 80
      targetPort: 80
YAML

cat > "$D/telemetry/kustomization.yaml" <<'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: orbit
resources:
  - deployment.yaml
  - service.yaml
YAML

# Stable app (managed by the kustomization above)
kubectl apply -k "$D/telemetry" || true

# Canary running the candidate image, NOT part of the kustomization
kubectl apply -f - <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: telemetry-canary
  namespace: orbit
  labels:
    app: telemetry
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: telemetry
      track: canary
  template:
    metadata:
      labels:
        app: telemetry
        track: canary
    spec:
      containers:
        - name: web
          image: nginx:1.26
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 64Mi
YAML

echo "Setup complete for Question 12"
exit 0
