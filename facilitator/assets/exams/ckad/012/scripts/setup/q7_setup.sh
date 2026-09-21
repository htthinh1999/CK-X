#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mkdir -p /tmp/exam/course/7/image
cat > /tmp/exam/course/7/image/Dockerfile <<'EOF'
FROM nginx:1.25-alpine@sha256:516475cc129da42866742567714ddc681e5eed7b9ee0b9e9c015e464b4221a00
LABEL maintainer="ckad-exam"
LABEL app="oni-app"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
EOF
cat > /tmp/exam/course/7/image/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Oni App</title></head>
<body><h1>Oni App v1.0</h1></body>
</html>
EOF
docker rm -f registry >/dev/null 2>&1 || true
docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true
echo "Setup complete for Question 7"
exit 0
