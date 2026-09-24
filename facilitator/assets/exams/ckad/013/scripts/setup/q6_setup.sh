#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace eclipse --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/6
cat > /tmp/exam/course/6/app.env <<'EOF'
APP_NAME=solar-dashboard
APP_PORT=8080
APP_ENV=production
LOG_LEVEL=info
DB_HOST=db.eclipse.svc.cluster.local
EOF
echo "Setup complete for Question 6"
exit 0
