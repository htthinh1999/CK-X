#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace flare --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/13
cat > /tmp/exam/course/13/values.yaml <<'EOF'
# Q13 - Helm Values Override File
# Task: Use this file to override default nginx chart values
---
replicaCount: 3

image:
  tag: "latest"

service:
  type: ClusterIP
  ports:
    http: 8080

resources:
  requests:
    memory: "64Mi"
    cpu: "100m"
  limits:
    memory: "128Mi"
    cpu: "200m"
EOF
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
helm repo update 2>/dev/null || true

echo "Setup complete for Question 13"
exit 0
