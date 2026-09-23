#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=platform
DIR=/home/candidate/exam/q5

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete ingress --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete service departures arrivals arrivals-live --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete deployment departures-web arrivals-web arrivals-legacy --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pod --all --grace-period=0 --force --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl apply -f - >/dev/null <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: departures-conf
  namespace: platform
data:
  default.conf: |
    server {
        listen 8080;
        location / {
            default_type text/plain;
            return 200 "board=departures build=d-2291 host=$host xfh=$http_x_forwarded_host uri=$request_uri\n";
        }
    }
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: arrivals-conf
  namespace: platform
data:
  default.conf: |
    server {
        listen 8080;
        location / {
            default_type text/plain;
            return 200 "board=arrivals build=a-4410 host=$host xfh=$http_x_forwarded_host uri=$request_uri\n";
        }
    }
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: arrivals-legacy-conf
  namespace: platform
data:
  default.conf: |
    server {
        listen 8080;
        location / {
            default_type text/plain;
            return 200 "board=arrivals build=legacy-0907 host=$host xfh=$http_x_forwarded_host uri=$request_uri\n";
        }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: departures-web
  namespace: platform
  labels: {app: departures}
spec:
  replicas: 2
  selector:
    matchLabels: {app: departures, track: live}
  template:
    metadata:
      labels: {app: departures, track: live}
    spec:
      containers:
      - name: board
        image: nginx:1.25
        ports:
        - name: http
          containerPort: 8080
        volumeMounts:
        - name: conf
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: conf
        configMap:
          name: departures-conf
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: arrivals-web
  namespace: platform
  labels: {app: arrivals}
spec:
  replicas: 2
  selector:
    matchLabels: {app: arrivals, track: live}
  template:
    metadata:
      labels: {app: arrivals, track: live}
    spec:
      containers:
      - name: board
        image: nginx:1.25
        ports:
        - name: web
          containerPort: 8080
        volumeMounts:
        - name: conf
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: conf
        configMap:
          name: arrivals-conf
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: arrivals-legacy
  namespace: platform
  labels: {app: arrivals}
spec:
  replicas: 1
  selector:
    matchLabels: {app: arrivals, track: legacy}
  template:
    metadata:
      labels: {app: arrivals, track: legacy}
    spec:
      containers:
      - name: board
        image: nginx:1.25
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: conf
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: conf
        configMap:
          name: arrivals-legacy-conf
---
apiVersion: v1
kind: Service
metadata:
  name: departures
  namespace: platform
spec:
  selector: {app: departures, track: live}
  ports:
  - port: 80
    targetPort: http
---
apiVersion: v1
kind: Service
metadata:
  name: arrivals
  namespace: platform
  annotations:
    transit.io/note: "old arrivals board"
spec:
  selector: {app: arrivals, track: legacy}
  ports:
  - port: 80
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: arrivals-live
  namespace: platform
spec:
  selector: {app: arrivals, track: live}
  ports:
  - name: board
    port: 8081
    targetPort: web
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: platform-status
  namespace: platform
spec:
  ingressClassName: traefik
  rules:
  - host: status.transit.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: departures
            port:
              number: 80
EOF

kubectl -n "$NS" rollout status deployment/departures-web --timeout=120s >/dev/null 2>&1 || true
kubectl -n "$NS" rollout status deployment/arrivals-web --timeout=120s >/dev/null 2>&1 || true
kubectl -n "$NS" rollout status deployment/arrivals-legacy --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 5"
exit 0
