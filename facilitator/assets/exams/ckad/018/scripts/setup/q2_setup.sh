#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace harmony --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod wisdom-server -n harmony --ignore-not-found=true 2>/dev/null || true
# provide app source and a starter Dockerfile
mkdir -p /tmp/exam/course/2/app
echo "Benzaiten Wisdom" > /tmp/exam/course/2/app/index.html
cat > /tmp/exam/course/2/Dockerfile <<'EOF_FILE'
FROM nginx:alpine
# TODO: Complete Dockerfile
EOF_FILE
# start a throwaway local registry so docker push works
docker rm -f registry 2>/dev/null || true
docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true
echo "Setup complete for Question 2"
exit 0
