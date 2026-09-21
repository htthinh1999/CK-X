#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace tempo --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod metrics-pod -n tempo --ignore-not-found=true 2>/dev/null || true
kubectl delete configmap metrics-config -n tempo --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: metrics-pod
  namespace: tempo
spec:
  containers:
  - name: main
    image: nginx:alpine
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: metrics-config
EOF
echo "Setup complete for Question 9"
exit 0
