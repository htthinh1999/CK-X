#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace inferno --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/12/image
cat > /tmp/exam/course/12/image/Dockerfile <<'EOF'
FROM nginx:1.21

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF
cat > /tmp/exam/course/12/image/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Phoenix App</title>
</head>
<body>
    <h1>Welcome to Phoenix App</h1>
    <p>Fire rises from the ashes.</p>
</body>
</html>
EOF
docker rm -f registry 2>/dev/null || true
docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true

echo "Setup complete for Question 12"
exit 0
