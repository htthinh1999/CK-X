#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace flame --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl apply -f - <<'EOF' || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-settings
  namespace: flame
  labels:
    exam: ckad-simulation1
data:
  database.host: "db.flame.svc.cluster.local"
  database.port: "5432"
  cache.host: "redis.flame.svc.cluster.local"
  cache.port: "6379"
  log.level: "info"
  app.name: "phoenix-app"
EOF

echo "Setup complete for Question 6"
exit 0
