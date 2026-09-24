#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tracker --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

D=/home/candidate/exam/q15
rm -rf "$D"
mkdir -p "$D"

# Start state: no PDB / HPA yet.
kubectl -n tracker delete hpa satpos-hpa --ignore-not-found >/dev/null 2>&1 || true
kubectl -n tracker delete pdb satpos-pdb --ignore-not-found >/dev/null 2>&1 || true

kubectl apply -f - <<'YAML' || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: satpos
  namespace: tracker
  labels:
    app: satpos
spec:
  replicas: 2
  selector:
    matchLabels:
      app: satpos
  template:
    metadata:
      labels:
        app: satpos
    spec:
      containers:
        - name: satpos
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 100m
              memory: 128Mi
YAML

# Manifest written against the removed policy/v1beta1 API (apply fails on v1.25+).
cat > "$D/satpos-pdb.yaml" <<'YAML'
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: satpos-pdb
  namespace: tracker
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: satpos
YAML

echo "Setup complete for Question 15"
exit 0
