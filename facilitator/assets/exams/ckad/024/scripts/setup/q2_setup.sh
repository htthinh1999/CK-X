#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace quayside --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
rm -rf /home/candidate/exam/q2 && mkdir -p /home/candidate/exam/q2

# Start from a clean revision history so the revisions are exactly 1, 2, 3.
kubectl -n quayside delete deployment crane --ignore-not-found --cascade=foreground --wait=true --timeout=60s >/dev/null 2>&1 || true

# $1 = change-cause, $2 = image, $3 = optional env block
crane_manifest() {
  cat <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crane
  namespace: quayside
  labels:
    app: crane
  annotations:
    kubernetes.io/change-cause: "$1"
spec:
  replicas: 3
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 120
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: crane
  template:
    metadata:
      labels:
        app: crane
    spec:
      containers:
        - name: hoist
          image: $2
          ports:
            - containerPort: 80
$3
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 64Mi
YAML
}

ENV_BLOCK='          env:
            - name: LIFT_MODE
              value: tandem'

# Revision 1: initial release (works)
crane_manifest "initial release on nginx:1.25" "nginx:1.25" "" | kubectl apply -f - >/dev/null 2>&1 || true
kubectl -n quayside rollout status deployment/crane --timeout=120s >/dev/null 2>&1 || true

# Revision 2: config change (works) - this is the last good revision
crane_manifest "enable tandem lift mode" "nginx:1.25" "$ENV_BLOCK" | kubectl apply -f - >/dev/null 2>&1 || true
kubectl -n quayside rollout status deployment/crane --timeout=120s >/dev/null 2>&1 || true

# Revision 3: broken image tag (pods stuck in ErrImagePull / ImagePullBackOff)
crane_manifest "upgrade image to nginx:1.25-harbor" "nginx:1.25-harbor" "$ENV_BLOCK" | kubectl apply -f - >/dev/null 2>&1 || true
kubectl -n quayside wait deployment/crane \
  --for=jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}'=3 \
  --timeout=60s >/dev/null 2>&1 || true

echo "Setup complete for Question 2"
exit 0
