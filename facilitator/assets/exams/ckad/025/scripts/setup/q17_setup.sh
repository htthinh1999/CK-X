#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectro
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Reset: no namespace defaults, fresh Deployment
kubectl -n "$NS" delete limitrange --all >/dev/null 2>&1 || true
kubectl -n "$NS" delete deployment prism --ignore-not-found >/dev/null 2>&1 || true

# Quota that forces every container to declare cpu/memory requests and limits
cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: v1
kind: ResourceQuota
metadata:
  name: spectro-budget
  namespace: spectro
spec:
  hard:
    pods: "6"
    requests.cpu: 400m
    requests.memory: 512Mi
    limits.cpu: "1"
    limits.memory: 1Gi
YAML

# Let the quota controller populate the quota status (bounded)
for i in $(seq 1 20); do
  [ -n "$(kubectl -n "$NS" get resourcequota spectro-budget -o jsonpath='{.status.hard.pods}' 2>/dev/null)" ] && break
  sleep 1
done

# Deployment without any resources: its pods are rejected by the quota
cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prism
  namespace: spectro
  labels:
    app: prism
spec:
  replicas: 3
  selector:
    matchLabels:
      app: prism
  template:
    metadata:
      labels:
        app: prism
    spec:
      containers:
        - name: analyzer
          image: nginx:1.25
          ports:
            - containerPort: 80
YAML

echo "Setup complete for Question 17"
exit 0
