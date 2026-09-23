#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signals
DIR=/home/candidate/exam/q3

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete pod signal-box --grace-period=0 --force --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap box-template box-template-v1 aspect-table --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl apply -f - >/dev/null <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: box-template
  namespace: signals
  labels: {app: signal-box, revision: "2"}
data:
  box.conf.tpl: |
    # signal box runtime configuration
    box.id=%POD_NAME%
    box.interlocking=%NODE_NAME%
    box.cpu.millicores=%CPU_LIMIT%
    box.aspects=4
    box.log=/var/log/signal/%POD_NAME%/%POD_NAME%.log
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: box-template-v1
  namespace: signals
  labels: {app: signal-box, revision: "1"}
  annotations:
    transit.io/superseded-by: box-template
data:
  box.conf.tpl: |
    # signal box configuration (v1)
    id={{POD}}
    host={{NODE}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: aspect-table
  namespace: signals
  labels: {app: signal-box}
data:
  aspects: "red,yellow,double-yellow,green"
EOF

echo "Setup complete for Question 3"
exit 0
