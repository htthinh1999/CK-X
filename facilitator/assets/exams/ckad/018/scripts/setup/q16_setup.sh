#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace lyric --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete ingress multi-tls-ingress -n lyric --ignore-not-found=true 2>/dev/null || true
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: app1-svc
  namespace: lyric
spec:
  ports:
  - port: 80
  selector:
    app: app1
---
apiVersion: v1
kind: Service
metadata:
  name: app2-svc
  namespace: lyric
spec:
  ports:
  - port: 80
  selector:
    app: app2
---
apiVersion: v1
kind: Secret
metadata:
  name: app1-tls
  namespace: lyric
type: kubernetes.io/tls
data:
  tls.crt: base64crt
  tls.key: base64key
---
apiVersion: v1
kind: Secret
metadata:
  name: app2-tls
  namespace: lyric
type: kubernetes.io/tls
data:
  tls.crt: base64crt
  tls.key: base64key
EOF
echo "Setup complete for Question 16"
exit 0
