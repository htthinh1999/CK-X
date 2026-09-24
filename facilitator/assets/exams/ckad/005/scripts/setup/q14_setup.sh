#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mkdir -p /tmp/exam/course/14
kubectl create namespace jungle --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
# Pods in namespace jungle for `kubectl top` to report on (same Deployment as Q7's
# setup; Q13 runs on a different server/cluster, so it must create them itself).
kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
  namespace: jungle
  labels:
    app: critical-app
    exam: ckad-simulation3
spec:
  replicas: 5
  selector:
    matchLabels:
      app: critical-app
  template:
    metadata:
      labels:
        app: critical-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
YAML
echo "Setup complete for Question 14"
exit 0
