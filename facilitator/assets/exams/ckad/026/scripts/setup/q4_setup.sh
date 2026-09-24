#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=depot
DIR=/home/candidate/exam/q4

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment --all --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod --all --grace-period=0 --force --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

# The depot node is the (first) worker node; fall back to the only node.
NODE=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

# Reset depot labels/taints on every node, then mark the depot node
for n in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
  kubectl label node "$n" transit.io/pool- transit.io/lane- >/dev/null 2>&1 || true
  kubectl taint node "$n" dedicated- >/dev/null 2>&1 || true
  [ "$n" != "$NODE" ] && kubectl label node "$n" transit.io/lane=freight-a --overwrite >/dev/null 2>&1
done
kubectl label node "$NODE" transit.io/pool=depot transit.io/lane=freight-b --overwrite >/dev/null 2>&1 || true
kubectl taint node "$NODE" dedicated=depot:NoSchedule --overwrite >/dev/null 2>&1 || true

kubectl apply -f - >/dev/null <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wagon-sorter
  namespace: depot
  labels: {app: wagon-sorter, team: yard}
spec:
  replicas: 3
  selector:
    matchLabels: {app: wagon-sorter}
  template:
    metadata:
      labels: {app: wagon-sorter, team: yard}
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: transit.io/pool
                operator: In
                values: ["depot"]
              - key: transit.io/lane
                operator: In
                values: ["freight-a"]
      tolerations:
      - key: dedicated
        operator: Equal
        value: depot
        effect: NoExecute
      containers:
      - name: sorter
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests: {cpu: 20m, memory: 32Mi}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wagon-counter
  namespace: depot
  labels: {app: wagon-counter, team: yard}
spec:
  replicas: 2
  selector:
    matchLabels: {app: wagon-counter}
  template:
    metadata:
      labels: {app: wagon-counter, team: yard}
    spec:
      containers:
      - name: counter
        image: nginx:1.25
        resources:
          requests: {cpu: 10m, memory: 16Mi}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wagon-sorter-legacy
  namespace: depot
  labels: {app: wagon-sorter-legacy, team: yard}
  annotations:
    transit.io/retired: "true"
spec:
  replicas: 0
  selector:
    matchLabels: {app: wagon-sorter-legacy}
  template:
    metadata:
      labels: {app: wagon-sorter-legacy, team: yard}
    spec:
      nodeSelector:
        transit.io/lane: freight-a
      containers:
      - name: sorter
        image: nginx:1.25
EOF

kubectl -n "$NS" rollout status deployment/wagon-counter --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 4"
exit 0
