#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mkdir -p /tmp/exam/course/8
cat > /tmp/exam/course/8/broken-deploy.yaml <<'EOF'
# Q8: Broken Deployment YAML with intentional errors
# 1. Uses deprecated API version (extensions/v1beta1)
# 2. Missing required selector field
# 3. Template labels don't match (if selector was present)
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: broken-app
  namespace: default
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: web
          image: nginx
          ports:
            - containerPort: 80
EOF
echo "Setup complete for Question 8"
exit 0
