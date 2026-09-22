#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace bulwark --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/8
cat > /tmp/exam/course/8/deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
YAML
cat > /tmp/exam/course/8/kustomization.yaml <<'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
YAML
echo "Setup complete for Question 8"
exit 0
