#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mkdir -p /tmp/exam/course/3
cat > /tmp/exam/course/3/Dockerfile <<'EOF'
FROM nginx:alpine
RUN echo "Fujin API v2" > /usr/share/nginx/html/index.html
EXPOSE 80
EOF
docker rm -f registry 2>/dev/null; docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true
echo "Setup complete for Question 3"
exit 0
