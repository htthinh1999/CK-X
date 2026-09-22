#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace mistral --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mistral-db
  namespace: mistral
spec:
  serviceName: "mistral-db-headless"
  replicas: 1
  selector:
    matchLabels:
      app: mistral-db
  template:
    metadata:
      labels:
        app: mistral-db
    spec:
      containers:
      - name: db
        image: mysql:5.7
        env:
        - name: MYSQL_ALLOW_EMPTY_PASSWORD
          value: "1"
EOF
echo "Setup complete for Question 19"
exit 0
