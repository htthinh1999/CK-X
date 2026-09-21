#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace tide --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/12/config-files
cat > /tmp/exam/course/12/config-files/settings.conf <<'EOF'
app_mode=production
timeout=30
retry=5
EOF
cat > /tmp/exam/course/12/config-files/app.conf <<'EOF'
key1=value1
EOF
echo "Setup complete for Question 12"
exit 0
