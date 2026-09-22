#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mkdir -p /tmp/exam/course/5/image
cat > /tmp/exam/course/5/image/Dockerfile <<'EOF'
FROM nginx:alpine
LABEL maintainer="ckad-dojo"
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
cat > /tmp/exam/course/5/image/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>My App</title>
</head>
<body>
    <h1>Welcome to My App v1.0</h1>
    <p>Built with CKAD Dojo Kappa</p>
</body>
</html>
EOF
echo "Setup complete for Question 5"
exit 0
