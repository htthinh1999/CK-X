#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=freight
DIR=/home/candidate/exam/q18

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment freight-api --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete rolebinding --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete role --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete serviceaccount freight-reader freight-writer --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod --all --grace-period=0 --force --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl apply -f - >/dev/null <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: route-key
  namespace: freight
type: Opaque
stringData:
  key: rk-7781-alpha
---
apiVersion: v1
kind: Secret
metadata:
  name: route-key-backup
  namespace: freight
type: Opaque
stringData:
  key: rk-6620-beta
---
apiVersion: v1
kind: Secret
metadata:
  name: tariff-db
  namespace: freight
type: Opaque
stringData:
  DB_USER: tariff
  DB_PASSWORD: tariff-pw
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: freight-routes
  namespace: freight
data:
  routes: "north-yard,harbour-spur,east-loop"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: freight-tariffs
  namespace: freight
data:
  base: "12.50"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: freight-writer
  namespace: freight
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: freight-writer
  namespace: freight
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "create", "update", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: freight-writer
  namespace: freight
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: freight-writer
subjects:
- kind: ServiceAccount
  name: freight-writer
  namespace: freight
---
# Left over from an incident: grants far more than read access
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: freight-oncall
  namespace: freight
  annotations:
    transit.io/ticket: "OPS-4471"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: yardmaster
- kind: ServiceAccount
  name: freight-reader
  namespace: freight
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: freight-api
  namespace: freight
  labels: {app: freight-api}
spec:
  replicas: 2
  selector:
    matchLabels: {app: freight-api}
  template:
    metadata:
      labels: {app: freight-api}
    spec:
      automountServiceAccountToken: false
      containers:
      - name: api
        image: busybox:1.36
        command: ["sh", "-c", "while true; do ls /var/run/secrets/kubernetes.io/serviceaccount/ 2>/dev/null || echo 'no API token mounted'; sleep 30; done"]
        resources:
          requests: {cpu: 10m, memory: 16Mi}
EOF

kubectl -n "$NS" rollout status deployment/freight-api --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 18"
exit 0
