#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Namespace
kubectl create namespace genesis --dry-run=client -o yaml | kubectl apply -f - || true

# Start a throwaway local registry so docker push localhost:5000/... works
docker rm -f registry 2>/dev/null
docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true

# Provide the skeleton Dockerfile (student must add USER 1000)
mkdir -p /tmp/exam/course/1
cat > /tmp/exam/course/1/Dockerfile <<'EOF'
FROM nginx:1.21

RUN echo "Hello World" > /usr/share/nginx/html/index.html

# TODO: Add instruction to create user 'izanagi' with UID 1000 and switch to it

CMD ["nginx", "-g", "daemon off;"]
EOF

echo "Setup complete for Question 1"
exit 0
