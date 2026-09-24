#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace verse --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete deployment legacy-app -n verse --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy-app
  namespace: verse
spec:
  replicas: 1
  selector:
    matchLabels:
      app: legacy
  template:
    metadata:
      labels:
        app: legacy
    spec:
      containers:
      - name: app
        image: nginx:1.14
EOF
kubectl rollout status deployment/legacy-app -n verse --timeout=60s 2>/dev/null || true
kubectl set image deployment/legacy-app -n verse app=nginx:1.15 2>/dev/null || true
kubectl rollout status deployment/legacy-app -n verse --timeout=60s 2>/dev/null || true
kubectl set image deployment/legacy-app -n verse app=nginx:1.16 2>/dev/null || true
kubectl rollout status deployment/legacy-app -n verse --timeout=60s 2>/dev/null || true
kubectl set image deployment/legacy-app -n verse app=nginx:missing-tag 2>/dev/null || true
echo "Setup complete for Question 19"
exit 0
