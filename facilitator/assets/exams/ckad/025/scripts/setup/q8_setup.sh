#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=calibration
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Reset: the new ConfigMap is created by the student
kubectl -n "$NS" delete configmap optics-v2 --ignore-not-found >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null 2>&1 || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: optics-v1
  namespace: calibration
data:
  FOCAL_LENGTH: "1200"
  APERTURE: "f8"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lens-calibrator
  namespace: calibration
  labels:
    app: lens-calibrator
spec:
  replicas: 2
  selector:
    matchLabels:
      app: lens-calibrator
  template:
    metadata:
      labels:
        app: lens-calibrator
    spec:
      containers:
        - name: calibrator
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 100m
              memory: 128Mi
          volumeMounts:
            - name: optics
              mountPath: /etc/lens
              readOnly: true
      volumes:
        - name: optics
          configMap:
            name: optics-v1
YAML

kubectl -n "$NS" rollout status deployment/lens-calibrator --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 8"
exit 0
