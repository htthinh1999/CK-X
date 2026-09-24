# CKAD Simulation 14 — Answers

> Dojo Raijin ⚡ — *「雷神は天を裂く」- Raijin splits the heavens*
>
> Path mapping for this lab: `/opt/course/N/` and `./exam/course/N/` from the original are all under `/tmp/exam/course/N/`. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | ConfigMap as Command Args

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/1
kubectl create configmap app-args --from-literal=mode=verbose -n voltage
cat <<EOF > /tmp/exam/course/1/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: arg-reader
  namespace: voltage
spec:
  containers:
  - name: arg-reader
    image: busybox
    command: ["echo"]
    args: ["\$(MODE)"]
    env:
    - name: MODE
      valueFrom:
        configMapKeyRef:
          name: app-args
          key: mode
  restartPolicy: Never
EOF
kubectl apply -f /tmp/exam/course/1/pod.yaml
```

---

## Question 2 | Container Image with Healthcheck

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/2
cat <<EOF > /tmp/exam/course/2/Dockerfile
FROM nginx:1.23-alpine
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
EOF
```

---

## Question 3 | ClusterRole and Binding

> Server: `ssh ckad9977`

```bash
kubectl create serviceaccount app-sa -n spark
kubectl create clusterrole secret-reader --verb=get,watch,list --resource=secrets
kubectl create clusterrolebinding secret-reader-binding \
  --clusterrole=secret-reader --serviceaccount=spark:app-sa
```

---

## Question 4 | Sidecar Logging and Filtering

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/4
cat <<EOF > /tmp/exam/course/4/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: thunder-logger
  namespace: thunder
spec:
  containers:
  - name: app-container
    image: busybox
    command: ['sh', '-c', 'while true; do echo "INFO: Processing request"; sleep 2; echo "ERROR: Connection timeout"; sleep 3; done > /var/log/app.log']
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  - name: error-tailer
    image: busybox
    command: ['sh', '-c', 'tail -f /var/log/app.log | grep ERROR']
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  volumes:
  - name: log-volume
    emptyDir: {}
EOF
kubectl apply -f /tmp/exam/course/4/pod.yaml
```

---

## Question 5 | NetworkPolicy AND Logic

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/5
cat <<EOF > /tmp/exam/course/5/netpol.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: strict-ingress
  namespace: charge
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          env: prod
      podSelector:
        matchLabels:
          role: api
    ports:
    - protocol: TCP
      port: 3306
EOF
kubectl apply -f /tmp/exam/course/5/netpol.yaml
```

The single `from` element containing both `namespaceSelector` and `podSelector` is the AND logic.

---

## Question 6 | Advanced CronJob

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/6
cat <<EOF > /tmp/exam/course/6/cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: lightning-strike
  namespace: bolt
spec:
  startingDeadlineSeconds: 15
  successfulJobsHistoryLimit: 2
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: lightning-strike
            image: busybox
            command:
            - echo
            - "Strike!"
          restartPolicy: OnFailure
EOF
kubectl apply -f /tmp/exam/course/6/cronjob.yaml
```

---

## Question 7 | Kustomize Strategic Merge Patch

> Server: `ssh ckad9988`

```bash
cat <<EOF > /tmp/exam/course/7/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
patchesStrategicMerge:
- patch.yaml
EOF

cat <<EOF > /tmp/exam/course/7/patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-worker
spec:
  template:
    spec:
      containers:
      - name: worker
        env:
        - name: APP_ENV
          value: production
EOF

kubectl apply -k /tmp/exam/course/7/ -n charge
```

---

## Question 8 | Init Container Dependency

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/8
cat <<EOF > /tmp/exam/course/8/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-wait
  namespace: storm
spec:
  initContainers:
  - name: wait-for-db
    image: busybox
    command: ['sh', '-c', 'until nslookup database-svc; do echo waiting for database; sleep 2; done;']
  containers:
  - name: main-app
    image: nginx:alpine
EOF
kubectl apply -f /tmp/exam/course/8/pod.yaml
```

---

## Question 9 | Ingress Default Backend

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/9
cat <<EOF > /tmp/exam/course/9/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: default-ing
  namespace: surge
spec:
  defaultBackend:
    service:
      name: fallback-svc
      port:
        number: 8080
EOF
kubectl apply -f /tmp/exam/course/9/ingress.yaml
```

---

## Question 10 | Troubleshoot CrashLoopBackOff

> Server: `ssh ckad9988`

Inspect the failing pod:

```bash
kubectl get pod data-processor -n flash
kubectl describe pod data-processor -n flash
kubectl logs data-processor -n flash
```

The container exits with `exit 1`. Recreate the pod with a command that keeps it running:

```bash
kubectl delete pod data-processor -n flash
mkdir -p /tmp/exam/course/10
cat <<EOF > /tmp/exam/course/10/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-processor
  namespace: flash
spec:
  containers:
  - name: processor
    image: busybox
    command: ["sh", "-c", "echo Starting...; sleep 3600"]
EOF
kubectl apply -f /tmp/exam/course/10/pod.yaml
```

The pod should now be `Running`.

---

## Question 11 | Service Session Affinity

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/11
cat <<EOF > /tmp/exam/course/11/svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: sticky-svc
  namespace: flash
spec:
  selector:
    app: sticky
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800
EOF
kubectl apply -f /tmp/exam/course/11/svc.yaml
```

---

## Question 12 | Kubectl Events

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/12
kubectl get events -n strike --sort-by='.metadata.creationTimestamp' > /tmp/exam/course/12/events.txt
```

---

## Question 13 | Port Forwarding

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/13
kubectl port-forward pod/hidden-api 9090:8080 -n strike &
PF_PID=$!
sleep 3
curl -s http://localhost:9090/status > /tmp/exam/course/13/response.txt
kill $PF_PID
```

The `hidden-api` pod runs `mendhak/http-https-echo`, so the response body echoes the request (`method`, `path`, `headers`), which is saved to `/tmp/exam/course/13/response.txt`.

---

## Question 14 | All Three Probes

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/14
cat <<EOF > /tmp/exam/course/14/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: complex-app
  namespace: plasma
spec:
  containers:
  - name: complex-app
    image: nginx:alpine
    ports:
    - containerPort: 80
    startupProbe:
      httpGet:
        path: /
        port: 80
      failureThreshold: 30
      periodSeconds: 1
    livenessProbe:
      tcpSocket:
        port: 80
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 5
      initialDelaySeconds: 5
EOF
kubectl apply -f /tmp/exam/course/14/pod.yaml
```

---

## Question 15 | Helm Template Overrides

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/15
helm template thunder-web /tmp/exam/course/15/chart --namespace surge \
  --set replicaCount=3 --set image.tag=latest > /tmp/exam/course/15/output.yaml
```

---

## Question 16 | Downward API

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/16
cat <<EOF > /tmp/exam/course/16/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-info
  namespace: thunder
spec:
  containers:
  - name: env-info
    image: busybox
    command: ['sleep', '3600']
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
EOF
kubectl apply -f /tmp/exam/course/16/pod.yaml
```

---

## Question 17 | Deployment Rollback

> Server: `ssh ckad9999`

```bash
kubectl rollout history deployment api-gateway -n voltage
kubectl rollout undo deployment api-gateway -n voltage --to-revision=1
kubectl rollout status deployment api-gateway -n voltage
```

Revision 1 uses image `nginx:1.23`.

---

## Question 18 | SecurityContext Capabilities

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/18
cat <<EOF > /tmp/exam/course/18/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-net
  namespace: bolt
spec:
  containers:
  - name: secure-net
    image: alpine
    command: ["sleep", "1d"]
    securityContext:
      capabilities:
        add: ["NET_ADMIN"]
        drop: ["ALL"]
EOF
kubectl apply -f /tmp/exam/course/18/pod.yaml
```

---

## Question 19 | Canary Deployment

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/19
cat <<EOF > /tmp/exam/course/19/backend-v2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-v2
  namespace: spark
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.23
EOF
kubectl apply -f /tmp/exam/course/19/backend-v2.yaml
```

Keep the pod template label `app: backend` identical to `backend-v1` so `backend-svc` selects both.

---

## Question 20 | Secret with stringData

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/20
cat <<EOF > /tmp/exam/course/20/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: storm
type: Opaque
stringData:
  username: admin
  password: supersecret123
EOF
kubectl apply -f /tmp/exam/course/20/secret.yaml
```
