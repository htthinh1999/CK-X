#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace charge --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete deployment api-worker -n charge --ignore-not-found=true >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/7
cat > /tmp/exam/course/7/deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-worker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-worker
  template:
    metadata:
      labels:
        app: api-worker
    spec:
      containers:
      - name: worker
        image: busybox
        command: ["sleep", "3600"]
YAML
# Remove any leftover student files so kustomization is authored by the candidate
rm -f /tmp/exam/course/7/kustomization.yaml /tmp/exam/course/7/patch.yaml 2>/dev/null || true
echo "Setup complete for Question 7"
exit 0
