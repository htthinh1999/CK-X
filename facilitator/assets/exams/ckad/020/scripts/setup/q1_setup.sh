#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace matrix --dry-run=client -o yaml | kubectl apply -f - || true

# Provide the kustomize starter files (student adds secretGenerator/generatorOptions)
mkdir -p /tmp/exam/course/1/kustomize

cat > /tmp/exam/course/1/kustomize/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml

# TODO: Add secretGenerator and generatorOptions
EOF

cat > /tmp/exam/course/1/kustomize/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: matrix-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: matrix-web
  template:
    metadata:
      labels:
        app: matrix-web
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
EOF

echo "Setup complete for Question 1"
exit 0
