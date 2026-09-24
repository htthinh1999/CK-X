#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace chorus --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
helm uninstall wisdom-app -n chorus 2>/dev/null || true
mkdir -p /tmp/exam/course/15/chart/templates
cat > /tmp/exam/course/15/chart/Chart.yaml <<'EOF'
apiVersion: v2
name: wisdom-app
version: 0.1.0
dependencies:
  - name: nginx
    version: 15.1.0
    repository: https://charts.bitnami.com/bitnami
EOF
cat > /tmp/exam/course/15/chart/values.yaml <<'EOF'
replicaCount: 1
service:
  port: 80
EOF
cat > /tmp/exam/course/15/values.yaml <<'EOF'
# override values here
EOF
echo "Setup complete for Question 15"
exit 0
