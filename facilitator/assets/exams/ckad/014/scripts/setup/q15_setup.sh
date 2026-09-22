#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace shadow --dry-run=client -o yaml | kubectl apply -f - || true

# Pre-create the compromised secret (old value) and the pod that mounts it.
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: legacy-token
  namespace: shadow
type: Opaque
data:
  token: c3VwZXItc2VjcmV0LXYx
---
apiVersion: v1
kind: Pod
metadata:
  name: token-reader
  namespace: shadow
spec:
  containers:
  - name: reader
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: secret-vol
      mountPath: /etc/secret
  volumes:
  - name: secret-vol
    secret:
      secretName: legacy-token
EOF

echo "Setup complete for Question 15"
exit 0
