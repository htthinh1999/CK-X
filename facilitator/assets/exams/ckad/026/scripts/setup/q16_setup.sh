#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=routes
D=/home/candidate/exam/q16

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Reset: remove every workload, Service and ConfigMap a previous run or attempt created
kubectl -n "$NS" delete deployment --all --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete service --all >/dev/null 2>&1 || true
for cm in $(kubectl -n "$NS" get configmap -o name 2>/dev/null | grep -v '^configmap/kube-root-ca.crt$'); do
  kubectl -n "$NS" delete "$cm" --ignore-not-found >/dev/null 2>&1 || true
done

rm -rf "$D"
mkdir -p "$D/base" "$D/overlays/staging"

cat > "$D/base/kustomization.yaml" <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
- service.yaml
configMapGenerator:
- name: route-settings
  literals:
  - ROUTE_MODE=standard
  - MAX_STOPS=40
  - FEED_URL=http://feed.routes.internal/v2
EOF

cat > "$D/base/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: route-board
  labels:
    app: route-board
spec:
  replicas: 1
  selector:
    matchLabels:
      app: route-board
  template:
    metadata:
      labels:
        app: route-board
    spec:
      containers:
      - name: web
        image: nginx:1.25
        ports:
        - containerPort: 80
        envFrom:
        - configMapRef:
            name: route-settings
      - name: feed-sync
        image: busybox:1.36
        command: ["sh", "-c", "while true; do cat /etc/route/FEED_URL; echo; sleep 300; done"]
        volumeMounts:
        - name: settings
          mountPath: /etc/route
      volumes:
      - name: settings
        configMap:
          name: route-settings
EOF

cat > "$D/base/service.yaml" <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: route-board
  labels:
    app: route-board
spec:
  selector:
    app: route-board
  ports:
  - name: http
    port: 80
    targetPort: 80
EOF

cat > "$D/overlays/staging/kustomization.yaml" <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../../base
namespace: routes
namePrefix: staging-
labels:
- pairs:
    env: staging
  includeSelectors: true
configMapGenerator:
- name: route-settings
  behavior: replace
  literals:
  - ROUTE_MODE=test
  - MAX_STOPS=5
patches:
- path: web-limits.yaml
EOF

cat > "$D/overlays/staging/web-limits.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: route-board
spec:
  template:
    spec:
      containers:
      - name: web
        resources:
          limits:
            memory: 64Mi
EOF

# The staging overlay is live in the same namespace
kubectl apply -k "$D/overlays/staging" >/dev/null

# An older hand-made copy that still carries the base label
cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: route-board-legacy
  namespace: routes
  labels:
    app: route-board
spec:
  replicas: 1
  selector:
    matchLabels:
      app: route-board
      release: legacy
  template:
    metadata:
      labels:
        app: route-board
        release: legacy
    spec:
      containers:
      - name: web
        image: nginx:1.25
        ports:
        - containerPort: 80
YAML

kubectl -n "$NS" rollout status deployment/staging-route-board --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 16"
exit 0
