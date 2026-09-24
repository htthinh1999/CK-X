#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace yard --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q9 && mkdir -p /home/candidate/exam/q9

# start clean: the student creates the HPA
kubectl -n yard delete hpa forklift-hpa --ignore-not-found >/dev/null 2>&1 || true

kubectl apply -f - <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: forklift
  namespace: yard
  labels:
    app: forklift
spec:
  replicas: 1
  selector:
    matchLabels:
      app: forklift
  template:
    metadata:
      labels:
        app: forklift
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 50m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 64Mi
YAML

# legacy manifest: autoscaling/v2beta2 is no longer served, so applying it fails
cat > /home/candidate/exam/q9/forklift-hpa.yaml <<'YAML'
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: forklift-hpa
  namespace: yard
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: forklift
  minReplicas: 1
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 80
YAML

echo "Setup complete for Question 9"
exit 0
