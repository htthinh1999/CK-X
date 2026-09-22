#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace strike --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/20
rm -f /tmp/exam/course/20/response.txt 2>/dev/null || true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: hidden-api
  namespace: strike
  labels:
    app: hidden
spec:
  containers:
  - name: api
    image: mendhak/http-https-echo
    ports:
    - containerPort: 8080
YAML
kubectl wait --for=condition=ready pod/hidden-api -n strike --timeout=90s || true
echo "Setup complete for Question 20"
exit 0
