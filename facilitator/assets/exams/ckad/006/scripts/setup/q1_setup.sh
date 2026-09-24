#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace delta --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: monitor-sa
  namespace: delta
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: wrong-sa
  namespace: delta
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-sa
  namespace: delta
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: metrics-reader
  namespace: delta
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: full-access
  namespace: delta
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: view-only
  namespace: delta
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: monitor-binding
  namespace: delta
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: metrics-reader
subjects:
  - kind: ServiceAccount
    name: monitor-sa
    namespace: delta
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin-binding
  namespace: delta
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: full-access
subjects:
  - kind: ServiceAccount
    name: admin-sa
    namespace: delta
---
apiVersion: v1
kind: Pod
metadata:
  name: metrics-pod
  namespace: delta
spec:
  serviceAccountName: wrong-sa
  containers:
    - name: metrics
      image: bitnami/kubectl:latest
      command:
        - /bin/sh
        - -c
        - |
          while true; do
            echo "Attempting to list pods in namespace delta..."
            kubectl get pods -n delta 2>&1
            sleep 10
          done
EOF
echo "Setup complete for Question 1"
exit 0
