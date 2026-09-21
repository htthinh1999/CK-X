#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace current --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/19
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-deployer
  namespace: current
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-deployer-role
  namespace: current
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create", "delete", "get", "list", "patch", "update"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-deployer-binding
  namespace: current
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-deployer-role
subjects:
- kind: ServiceAccount
  name: app-deployer
  namespace: current
EOF
echo "Setup complete for Question 19"
exit 0
