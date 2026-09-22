#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace zenith --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/7
cat > /tmp/exam/course/7/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: zenith
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
EOF
cat > /tmp/exam/course/7/service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: zenith
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
EOF
echo "Setup complete for Question 7"
exit 0
