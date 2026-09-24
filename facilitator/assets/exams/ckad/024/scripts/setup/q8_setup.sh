#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tally --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Nothing is applied yet: the student applies base + canary overlay.
kubectl -n tally delete deployment weighbridge weighbridge-canary --ignore-not-found >/dev/null 2>&1 || true
kubectl -n tally delete service weighbridge weighbridge-canary --ignore-not-found >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q8 && mkdir -p /home/candidate/exam/q8/base /home/candidate/exam/q8/overlays

cat > /home/candidate/exam/q8/base/kustomization.yaml <<'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: tally
resources:
  - deployment.yaml
  - service.yaml
YAML

cat > /home/candidate/exam/q8/base/deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: weighbridge
  labels:
    app: weighbridge
spec:
  replicas: 3
  selector:
    matchLabels:
      app: weighbridge
  template:
    metadata:
      labels:
        app: weighbridge
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 64Mi
YAML

cat > /home/candidate/exam/q8/base/service.yaml <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: weighbridge
  labels:
    app: weighbridge
spec:
  type: ClusterIP
  selector:
    app: weighbridge
  ports:
    - name: http
      port: 80
      targetPort: 80
YAML

echo "Setup complete for Question 8"
exit 0
