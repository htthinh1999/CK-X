#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace dome --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Deployment whose readiness probe points at the wrong port and path:
# its Pods run but never become Ready.
kubectl apply -f - <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: skyview
  namespace: dome
  labels:
    app: skyview
spec:
  replicas: 2
  selector:
    matchLabels:
      app: skyview
  template:
    metadata:
      labels:
        app: skyview
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 80
          readinessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 3
            periodSeconds: 5
            failureThreshold: 2
          livenessProbe:
            tcpSocket:
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 15
          resources:
            requests:
              cpu: 20m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 64Mi
YAML

echo "Setup complete for Question 5"
exit 0
