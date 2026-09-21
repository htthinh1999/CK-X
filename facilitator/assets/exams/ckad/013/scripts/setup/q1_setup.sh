#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mkdir -p /tmp/exam/course/1/image
cat > /tmp/exam/course/1/image/Dockerfile <<'EOF'
FROM nginx:1.25-alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
cat > /tmp/exam/course/1/image/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Solar App</title></head>
<body><h1>Welcome to Solar App v1.0</h1></body>
</html>
EOF
echo "Setup complete for Question 1"
exit 0
