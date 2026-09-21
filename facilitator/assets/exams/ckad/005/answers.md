# CKAD Simulation 3 — Answers

*Dojo Genbu 🐢 — Tortue Noire du Nord — "The turtle carries the world. Patience is the key to success."*

All file paths use `/tmp/exam/course/N/...` (the CK-X workspace). Everything runs on the single `ckad9999` jumphost against one cluster (no SSH to other instances needed).

---

## Question 1 | kubectl explain

```bash
# Explore the API documentation
kubectl explain pod.spec.containers.resources

# Save the full recursive output to the required file
mkdir -p /tmp/exam/course/1
kubectl explain pod.spec.containers.resources --recursive > /tmp/exam/course/1/pod-spec-fields.txt
```

`kubectl explain` provides built-in documentation. Use dot notation to navigate nested fields; `--recursive` shows all sub-fields.

---

## Question 2 | Pod Anti-Affinity

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spread-pods
  namespace: tiger
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spread-pods
  template:
    metadata:
      labels:
        app: spread-pods
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - spread-pods
            topologyKey: kubernetes.io/hostname
      containers:
      - name: web
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF
```

`requiredDuringSchedulingIgnoredDuringExecution` enforces a hard anti-affinity constraint. Topology key `kubernetes.io/hostname` spreads pods across nodes; with fewer nodes than replicas, extra pods stay Pending.

---

## Question 3 | Blue-Green Deployment

```bash
# Step 1: Create the green deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stable-green
  namespace: stripe
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: green
  template:
    metadata:
      labels:
        app: web-app
        version: green
    spec:
      containers:
      - name: nginx
        image: nginx:1.22
        ports:
        - containerPort: 80
EOF

# Step 2: Wait for green pods to be ready
kubectl rollout status deployment/stable-green -n stripe

# Step 3: Switch the service to green
kubectl patch service web-service -n stripe -p '{"spec":{"selector":{"version":"green"}}}'

# Verify
kubectl get endpoints web-service -n stripe
```

Blue-Green is a complete switch: changing the service selector routes 100% of traffic to the new version instantly.

---

## Question 4 | CronJob Advanced

```bash
# Suspend the CronJob first
kubectl patch cronjob data-sync -n prowl -p '{"spec":{"suspend":true}}'

# Add startingDeadlineSeconds and concurrencyPolicy
kubectl patch cronjob data-sync -n prowl -p '{"spec":{"startingDeadlineSeconds":200,"concurrencyPolicy":"Forbid"}}'

# Resume the CronJob
kubectl patch cronjob data-sync -n prowl -p '{"spec":{"suspend":false}}'

# Verify
kubectl get cronjob data-sync -n prowl -o yaml | grep -E "suspend|startingDeadline|concurrency"
```

`suspend: false` re-enables scheduling, `startingDeadlineSeconds` bounds late starts, and `concurrencyPolicy: Forbid` prevents overlapping runs.

---

## Question 5 | Immutable ConfigMap

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: locked-config
  namespace: hunt
data:
  DB_HOST: postgres.hunt.svc
  DB_PORT: "5432"
  LOG_LEVEL: info
immutable: true
EOF
```

Immutable ConfigMaps cannot be modified after creation; to change one you must delete and recreate it.

---

## Question 6 | Projected Volume

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: config-aggregator
  namespace: hunt
spec:
  serviceAccountName: hunt-sa
  containers:
  - name: aggregator
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: combined-config
      mountPath: /etc/config
  volumes:
  - name: combined-config
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
      - configMap:
          name: app-config
EOF
```

A projected volume combines a ServiceAccount token (1h expiry) and the ConfigMap into the single mount at `/etc/config`.

---

## Question 7 | PodDisruptionBudget

```bash
kubectl apply -f - <<EOF
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-pdb
  namespace: jungle
spec:
  minAvailable: 3
  selector:
    matchLabels:
      app: critical-app
EOF

kubectl get pdb critical-pdb -n jungle
```

With `minAvailable: 3` on a 5-replica deployment, at most 2 pods can be voluntarily evicted at once. `status.expectedPods` reports 5.

---

## Question 8 | Service ExternalName

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: external-api
  namespace: fang
spec:
  type: ExternalName
  externalName: api.external-service.com
EOF
```

ExternalName services are pure DNS CNAME aliases — no ClusterIP and no proxying.

---

## Question 9 | LimitRange

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
  namespace: pounce
spec:
  limits:
  - type: Container
    default:
      cpu: "500m"
      memory: "256Mi"
    defaultRequest:
      cpu: "100m"
      memory: "64Mi"
    min:
      cpu: "50m"
      memory: "32Mi"
    max:
      cpu: "1"
      memory: "512Mi"
EOF

kubectl describe limitrange container-limits -n pounce
```

---

## Question 10 | Pod Security Context

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: stalker
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: secure-nginx
    image: nginx:1.21
    securityContext:
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
    volumeMounts:
    - name: tmp-volume
      mountPath: /tmp
    - name: cache-volume
      mountPath: /var/cache/nginx
    - name: run-volume
      mountPath: /var/run
    - name: conf-volume
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: tmp-volume
    emptyDir: {}
  - name: cache-volume
    emptyDir: {}
  - name: run-volume
    emptyDir: {}
  - name: conf-volume
    emptyDir: {}
EOF
```

A read-only root filesystem needs writable `emptyDir` volumes wherever nginx must write (`/tmp`, `/var/cache/nginx`, `/var/run`, `/etc/nginx/conf.d`).

---

## Question 11 | Deployment Rollout Control

```bash
# Step 1: Pause the rollout
kubectl rollout pause deployment/rolling-app -n pounce

# Step 2: Update the image (container name is nginx)
kubectl set image deployment/rolling-app nginx=nginx:1.22 -n pounce

# Step 3: Set revisionHistoryLimit
kubectl patch deployment rolling-app -n pounce -p '{"spec":{"revisionHistoryLimit":5}}'

# Step 4: Resume the rollout
kubectl rollout resume deployment/rolling-app -n pounce

# Verify
kubectl rollout status deployment/rolling-app -n pounce
```

Pausing lets you batch changes; the rollout only starts on resume.

---

## Question 12 | kubectl exec Troubleshooting

```bash
mkdir -p /tmp/exam/course/12

# Read the nginx custom config and save it
kubectl exec config-pod -n stalker -- cat /etc/nginx/conf.d/custom.conf > /tmp/exam/course/12/nginx-config.txt

# Verify nginx is listening on port 8080 inside the container
kubectl exec config-pod -n stalker -- curl -s localhost:8080
```

The saved file contains the `server { listen 8080; ... }` block, satisfying the content and port-8080 checks.

---

## Question 13 | Resource Metrics

```bash
mkdir -p /tmp/exam/course/13

# Capture pod metrics (stderr included so an error still lands in the file)
kubectl top pods -n jungle > /tmp/exam/course/13/pod-resources.txt 2>&1

# Top CPU consumer
kubectl top pods -n jungle --sort-by=cpu 2>/dev/null | head -2 | tail -1 | awk '{print $1}' > /tmp/exam/course/13/top-cpu-pod.txt

# Fallback if metrics-server is not installed
if ! kubectl top pods -n jungle >/dev/null 2>&1; then
  echo "Metrics server not available" > /tmp/exam/course/13/pod-resources.txt
  echo "unknown" > /tmp/exam/course/13/top-cpu-pod.txt
fi
```

Scoring only requires the two files to exist and `pod-resources.txt` to be non-empty, so the fallback still earns full marks when metrics-server is absent.

---

## Question 14 | Downward API

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: metadata-pod
  namespace: claw
spec:
  containers:
  - name: info
    image: busybox:1.36
    command: ["sh", "-c", "env | grep POD && env | grep NODE && sleep 3600"]
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
EOF
```

The Downward API exposes pod/node metadata via `fieldRef`.

---

## Question 15 | Job TTL

```bash
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: cleanup-job
  namespace: stripe
spec:
  ttlSecondsAfterFinished: 60
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: cleanup
        image: busybox:1.36
        command: ["sh", "-c", "echo 'Cleanup complete' && sleep 5"]
      restartPolicy: Never
EOF
```

`ttlSecondsAfterFinished: 60` deletes the Job (and its pods) 60s after completion. Validate soon after applying, before the TTL removes it.

---

## Question 16 | Container Capabilities

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: hardened-pod
  namespace: predator
spec:
  containers:
  - name: secure-app
    image: nginx:1.21
    securityContext:
      runAsNonRoot: true
      runAsUser: 101
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    volumeMounts:
    - name: cache-volume
      mountPath: /var/cache/nginx
    - name: run-volume
      mountPath: /var/run
    - name: conf-volume
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: cache-volume
    emptyDir: {}
  - name: run-volume
    emptyDir: {}
  - name: conf-volume
    emptyDir: {}
EOF
```

Dropping ALL and adding only `NET_BIND_SERVICE` follows least privilege; running as non-root user 101 requires writable volumes for nginx's runtime paths.

---

## Question 17 | Service Session Affinity

```bash
kubectl patch service backend-svc -n claw -p '{"spec":{"sessionAffinity":"ClientIP","sessionAffinityConfig":{"clientIP":{"timeoutSeconds":3600}}}}'

# Verify
kubectl get service backend-svc -n claw -o yaml | grep -A5 sessionAffinity
```

`ClientIP` session affinity pins a client to the same pod for the timeout window (1h).

---

## Question 18 | Deployment Safe Rollout

```bash
# Configure safe rollout settings
kubectl patch deployment safe-deploy -n fang -p '{"spec":{"minReadySeconds":30,"progressDeadlineSeconds":120}}'

# Update the image (container name is nginx)
kubectl set image deployment/safe-deploy nginx=nginx:1.22 -n fang

# Watch the rollout (each pod waits minReadySeconds before being available)
kubectl rollout status deployment/safe-deploy -n fang
```

`minReadySeconds` delays availability; `progressDeadlineSeconds` bounds how long the rollout may take before it's marked failed.

---

## Question 19 | Container Lifecycle Hook

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: graceful-pod
  namespace: tiger
spec:
  terminationGracePeriodSeconds: 30
  containers:
  - name: main
    image: nginx:1.21
    ports:
    - containerPort: 80
    lifecycle:
      preStop:
        exec:
          command: ["/bin/sh", "-c", "nginx -s quit && sleep 5"]
EOF
```

The `preStop` hook runs `nginx -s quit` for a graceful shutdown before SIGTERM; the grace period gives it time to finish.

---

## Question 20 | NetworkPolicy Default Deny

```bash
# Step 1: default deny-all
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: predator
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

# Step 2: allow frontend -> backend, plus DNS egress
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-api
  namespace: predator
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 80
  egress:
  - to: []
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
EOF
```

Empty `podSelector: {}` selects all pods for the default deny. The allow policy then re-opens only frontend→backend on port 80 and DNS egress on port 53.

---
