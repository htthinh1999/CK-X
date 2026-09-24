# CKAD Simulation 1 — Answers

**Dojo Suzaku 🔥 — Phénix Vermillon du Sud**

> *「朱雀は灰から蘇る」 - The phoenix rises from the ashes. Every mistake forges your mastery.*

Total Score: 112 points | Passing Score: ~66% (74 points)

> Environment notes: each question names its instance — `ssh` to it and work there; that server's cluster is its only (default) context, so there is nothing to switch. The scratch/course workspace `/tmp/exam/course/N/...` lives on the question's server. A local registry runs at `localhost:5000` on the server of the image question.

---

## Question 1 | Headless Service

> Server: `ssh ckad9988`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: backend-headless
  namespace: corona
spec:
  clusterIP: None
  selector:
    app: backend
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
EOF
```

A headless service (`clusterIP: None`) returns pod IPs directly via DNS instead of a single cluster IP.

---

## Question 2 | Deployment Recreate Strategy

> Server: `ssh ckad9999`

```bash
cat <<EOF > /tmp/exam/course/2/fire-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fire-app
  namespace: blaze
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: fire-app
  template:
    metadata:
      labels:
        app: fire-app
    spec:
      containers:
      - name: fire-container
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF

kubectl apply -f /tmp/exam/course/2/fire-app.yaml
```

The `Recreate` strategy terminates all existing pods before creating new ones.

---

## Question 3 | API Resources

> Server: `ssh ckad9977`

```bash
kubectl api-resources > /tmp/exam/course/3/api-resources
```

`kubectl api-resources` lists all available API resources in the cluster including shortnames, API group, and whether they are namespaced.

---

## Question 4 | Job with Timeout

> Server: `ssh ckad9999`

```bash
cat <<EOF > /tmp/exam/course/4/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
  namespace: spark
spec:
  activeDeadlineSeconds: 60
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["sh", "-c", "echo 'Processing data...' && sleep 30 && echo 'Done'"]
      restartPolicy: Never
EOF

kubectl apply -f /tmp/exam/course/4/job.yaml
```

`activeDeadlineSeconds` sets the maximum duration for a Job; it is terminated if it runs longer.

---

## Question 5 | Canary Deployment

> Server: `ssh ckad9988`

```bash
# Canary deployment (starter at /tmp/exam/course/5/canary.yaml)
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary-v2
  namespace: blaze
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-frontend
      version: v2
  template:
    metadata:
      labels:
        app: web-frontend
        version: v2
    spec:
      containers:
      - name: nginx
        image: nginx:1.22
        ports:
        - containerPort: 80
EOF

# Service routing to BOTH stable and canary (selector has no version)
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: blaze
spec:
  type: ClusterIP
  selector:
    app: web-frontend
  ports:
  - port: 80
    targetPort: 80
EOF
```

The service selector (`app: web-frontend` only) matches both `stable-v1` (3 pods) and `canary-v2` (1 pod), giving an approximate 75%/25% split.

---

## Question 6 | Helm Template Debug

> Server: `ssh ckad9999`

```bash
# Render the manifests from the installed release
helm get manifest phoenix-web -n flare > /tmp/exam/course/6/rendered.yaml

# Alternative using helm template with the installed values:
# helm get values phoenix-web -n flare -o yaml > /tmp/phoenix-values.yaml
# helm template phoenix-web bitnami/nginx -n flare -f /tmp/phoenix-values.yaml > /tmp/exam/course/6/rendered.yaml
```

`helm get manifest` retrieves the rendered manifests from an already installed release; `helm template` renders chart templates locally.

---

## Question 7 | Sidecar Data Processing

> Server: `ssh ckad9988`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: data-transform
  namespace: phoenix
spec:
  containers:
  - name: producer
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo \$(date) >> /data/input.log; sleep 5; done"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  - name: transformer
    image: busybox:1.36
    command: ["sh", "-c", "tail -f /data/input.log | while read line; do echo \"PROCESSED: \$line\" >> /data/output.log; done"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  volumes:
  - name: shared-data
    emptyDir: {}
EOF
```

The sidecar pattern uses two containers sharing an `emptyDir` volume: the producer writes, the transformer processes.

---

## Question 8 | Guaranteed QoS Class

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: qos-guaranteed
  namespace: spark
spec:
  containers:
  - name: web
    image: nginx:1.21
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "100m"
EOF
```

Guaranteed QoS requires every container to set both CPU and memory requests AND limits, with requests equal to limits.

---

## Question 9 | Fix CrashLoopBackOff

> Server: `ssh ckad9999`

```bash
kubectl describe pod crash-app -n ember
kubectl logs crash-app -n ember

# The command "sleepx" is invalid — it should be "sleep".
kubectl delete pod crash-app -n ember

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: crash-app
  namespace: ember
  labels:
    app: crash-app
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sleep", "3600"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
      limits:
        memory: "64Mi"
        cpu: "100m"
EOF

kubectl get pod crash-app -n ember
```

CrashLoopBackOff here is caused by the non-existent command `sleepx`; fixing it to `sleep` lets the pod run.

---

## Question 10 | Cross-Namespace NetworkPolicy

> Server: `ssh ckad9988`

```bash
# The flame namespace is labelled name=flame (done in setup); if needed:
kubectl label namespace flame name=flame --overwrite

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-flame
  namespace: corona
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: flame
    ports:
    - protocol: TCP
      port: 80
EOF
```

`namespaceSelector` restricts ingress to pods from the `flame` namespace (matched by its `name=flame` label) on port 80.

---

## Question 11 | ServiceAccount Projected Token

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: token-pod
  namespace: magma
spec:
  serviceAccountName: fire-sa
  containers:
  - name: app
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: fire-token
      mountPath: /var/run/secrets/fire-token
      readOnly: true
  volumes:
  - name: fire-token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
          audience: api
EOF
```

Projected volumes mount ServiceAccount tokens with a configurable expiration and audience at a custom path.

---

## Question 12 | Docker Build with ARG

> Server: `ssh ckad9988`

```bash
# The template already exists at /tmp/exam/course/12/image/ (Dockerfile + index.html)
cat <<EOF > /tmp/exam/course/12/image/Dockerfile
FROM nginx:1.21

ARG APP_VERSION=1.0.0
LABEL version=\${APP_VERSION}

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

cd /tmp/exam/course/12/image
docker build --build-arg APP_VERSION=2.0.0 -t localhost:5000/phoenix-app:2.0.0 .

# Push to the local registry (started at localhost:5000 in setup)
docker push localhost:5000/phoenix-app:2.0.0
```

`ARG` defines a build-time variable; `LABEL version=${APP_VERSION}` stamps the image with the value passed via `--build-arg`.

---

## Question 13 | ConfigMap Items Mount

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: config-reader
  namespace: flame
spec:
  containers:
  - name: reader
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: config-volume
      mountPath: /config
  volumes:
  - name: config-volume
    configMap:
      name: app-settings
      items:
      - key: database.host
        path: database.host
      - key: database.port
        path: database.port
EOF
```

Using `items` in a ConfigMap volume selectively mounts specific keys as files.

---

## Question 14 | TCP Liveness Probe

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: tcp-health
  namespace: ember
spec:
  containers:
  - name: web
    image: nginx:1.21
    ports:
    - containerPort: 80
    livenessProbe:
      tcpSocket:
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 5
EOF
```

A `tcpSocket` probe succeeds when a TCP connection to the port can be established.

---

## Question 15 | Helm Values File

> Server: `ssh ckad9988`

```bash
# values.yaml already exists at /tmp/exam/course/15/values.yaml
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install phoenix-api bitnami/nginx \
  -n flare \
  -f /tmp/exam/course/15/values.yaml
```

The values file overrides the chart defaults (3 replicas, service port 8080).

---

## Question 16 | Service with Named Ports

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: flame
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - name: http
    port: 80
    targetPort: http-web
    protocol: TCP
  - name: https
    port: 443
    targetPort: https-web
    protocol: TCP
EOF
```

`targetPort` can reference a container's named port (`http-web`, `https-web`) instead of a number.

---

## Question 17 | PostStart Lifecycle Hook

> Server: `ssh ckad9988`

```bash
# Starter at /tmp/exam/course/17/lifecycle.yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle-pod
  namespace: phoenix
spec:
  containers:
  - name: main
    image: nginx:1.21
    ports:
    - containerPort: 80
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "echo 'Started at \$(date)' > /usr/share/nginx/html/started.txt"]
EOF
```

The `postStart` hook runs right after the container is created, writing `started.txt`.

---

## Question 18 | Secret from File

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/18
echo -n 'FirePhoenix2024!' > /tmp/exam/course/18/password.txt

kubectl create secret generic db-credentials \
  --from-file=password.txt=/tmp/exam/course/18/password.txt \
  -n magma
```

`--from-file` creates an Opaque secret whose key is the filename (`password.txt`). `echo -n` avoids a trailing newline.

---

## Question 19 | Field Selectors

> Server: `ssh ckad9977`

```bash
kubectl get pods --all-namespaces --field-selector=status.phase=Running \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' > /tmp/exam/course/19/running-pods.txt
```

`--field-selector=status.phase=Running` filters on resource fields rather than labels.

---

## Question 20 | Topology Spread Constraints

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spread-deploy
  namespace: blaze
spec:
  replicas: 4
  selector:
    matchLabels:
      app: spread-app
  template:
    metadata:
      labels:
        app: spread-app
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
          matchLabels:
            app: spread-app
      containers:
      - name: web
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF
```

`topologySpreadConstraints` distribute pods across nodes; `maxSkew: 1` keeps counts balanced, `ScheduleAnyway` still schedules if it can't be satisfied.

---

## Question 21 | Node Drain

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/21
cat <<'EOF' > /tmp/exam/course/21/drain-command.sh
kubectl drain worker-node-1 \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --timeout=60s
EOF
```

`kubectl drain` safely evicts pods: `--ignore-daemonsets` skips DaemonSet pods, `--delete-emptydir-data` allows evicting pods with emptyDir volumes, `--force` handles unmanaged pods, `--timeout=60s` bounds the wait. (Write only; do not execute.)
