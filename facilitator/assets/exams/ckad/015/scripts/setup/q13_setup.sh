#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tempest --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/13
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tempest-app
  namespace: tempest
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tempest
  template:
    metadata:
      labels:
        app: tempest
    spec:
      containers:
      - name: main
        image: nginx:1.22
        ports:
        - containerPort: 80
        env:
        - name: WIND_FORCE
          value: "high"
EOF
echo "Setup complete for Question 13"
exit 0
