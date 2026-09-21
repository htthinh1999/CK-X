#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace genesis --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the backend-api deployment and service in genesis
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: genesis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
    spec:
      containers:
      - name: api
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend-api
  namespace: genesis
spec:
  selector:
    app: backend-api
  ports:
  - port: 8080
    targetPort: 80
EOF

# Course dir + starter skeleton for the check script
mkdir -p /tmp/exam/course/11
cat > /tmp/exam/course/11/check.sh <<'EOF'
#!/bin/bash
# TODO: Complete this script per the task instructions
EOF
chmod +x /tmp/exam/course/11/check.sh
touch /tmp/exam/course/11/health.log

echo "Setup complete for Question 11"
exit 0
