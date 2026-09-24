#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace solstice --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-web
  namespace: solstice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-web
  template:
    metadata:
      labels:
        app: secure-web
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: secure-svc
  namespace: solstice
spec:
  selector:
    app: secure-web
  ports:
    - port: 443
      targetPort: 80
      protocol: TCP
EOF
if ! kubectl get secret secure-tls -n solstice >/dev/null 2>&1; then
  tmpdir=$(mktemp -d)
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$tmpdir/tls.key" \
    -out "$tmpdir/tls.crt" \
    -subj "/CN=secure.example.com" >/dev/null 2>&1 || true
  kubectl create secret tls secure-tls --cert="$tmpdir/tls.crt" --key="$tmpdir/tls.key" -n solstice >/dev/null 2>&1 || true
  rm -rf "$tmpdir"
fi
echo "Setup complete for Question 12"
exit 0
