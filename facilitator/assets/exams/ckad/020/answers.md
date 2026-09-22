# CKAD Simulation 18 — Answers

> Dojo Izanagi ✨ — *「イザナギは世界を創る」- Izanagi creates the world*
>
> Local simulator adaptations: `/opt/course/N/` → `/tmp/exam/course/N/`, registry → `localhost:5000`, one cluster per host: `ssh` to the server shown under each question heading and use its default context.

---

## Question 1 | Multi-Stage Dockerfile Build

> Server: `ssh ckad9999`

```bash
# 1. Modify Dockerfile
cat <<EOF > /tmp/exam/course/1/Dockerfile
FROM nginx:1.21

RUN echo "Hello World" > /usr/share/nginx/html/index.html

# Add instructions
RUN useradd -u 1000 izanagi
USER 1000

CMD ["nginx", "-g", "daemon off;"]
EOF

# 2. Build image
docker build -t localhost:5000/genesis-app:v1 /tmp/exam/course/1/

# 3. Push image (a local registry is running at localhost:5000)
docker push localhost:5000/genesis-app:v1

# 4. Create Pod
kubectl run genesis-pod -n genesis --image=localhost:5000/genesis-app:v1
```

**Explanation:** The `USER 1000` instruction sets the numeric user for the container image (checked via `docker image inspect ... .Config.User`). Build, tag, and push are standard docker commands.

---

## Question 2 | Adapter Pattern Sidecar

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: data-transformer
  namespace: origin
spec:
  volumes:
  - name: shared-data
    emptyDir: {}
  containers:
  - name: app-container
    image: busybox:1.32
    command: ['sh', '-c', 'while true; do echo "\$(date) - DATA" >> /var/log/app.log; sleep 5; done']
    volumeMounts:
    - name: shared-data
      mountPath: /var/log
  - name: adapter-container
    image: busybox:1.32
    command: ['sh', '-c', 'tail -f /var/log/app.log | sed "s/DATA/TRANSFORMED_DATA/g" > /var/log/transformed.log']
    volumeMounts:
    - name: shared-data
      mountPath: /var/log
EOF
```

**Explanation:** The adapter pattern uses an `emptyDir` volume shared between both containers, mounted at `/var/log` in each.

---

## Question 3 | Parallel Job with Completions

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: index-processor
  namespace: primal
spec:
  completions: 5
  parallelism: 2
  completionMode: Indexed
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.32
        command: ['sh', '-c', 'echo "Processing item \$JOB_COMPLETION_INDEX"']
      restartPolicy: Never
EOF
```

**Explanation:** Indexed jobs expose `$JOB_COMPLETION_INDEX` to each pod. `completions: 5`, `parallelism: 2`, `completionMode: Indexed`.

---

## Question 4 | Pod Lifecycle PreStop Hook

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: graceful-shutdown
  namespace: ancient
spec:
  terminationGracePeriodSeconds: 45
  containers:
  - name: nginx
    image: nginx:1.21
    lifecycle:
      preStop:
        exec:
          command: ["sh", "-c", "sleep 10 && nginx -s quit"]
EOF
```

**Explanation:** The `preStop` exec hook runs before SIGTERM; `terminationGracePeriodSeconds: 45` allows time for it to finish.

---

## Question 5 | Helm Release Values Override

> Server: `ssh ckad9999`

```bash
# Inspect the currently deployed values
helm get values genesis-web -n nexus -a

# Upgrade reusing existing custom values, changing only replicaCount
helm upgrade genesis-web /tmp/exam/course/5/genesis-web-chart -n nexus --reuse-values --set replicaCount=3

# Verify
helm get values genesis-web -n nexus -a
```

**Explanation:** `--reuse-values` preserves previously set custom values (e.g. `customLabel: initial-install`) while `--set replicaCount=3` applies the new change.

---

## Question 6 | Deployment Canary Split

> Server: `ssh ckad9999`

```bash
# Create Deployment
kubectl create deployment terra-web --image=nginx:1.21 --replicas=4 -n terra

# Create PDB
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: terra-pdb
  namespace: terra
spec:
  minAvailable: 75%
  selector:
    matchLabels:
      app: terra-web
EOF
```

**Explanation:** A PodDisruptionBudget with `minAvailable: 75%` keeps at least 75% of the `terra-web` pods available during voluntary disruptions.

---

## Question 7 | Deployment Rollback

> Server: `ssh ckad9999`

```bash
# Update image
kubectl set image deployment/eden-api nginx=nginx:1.21 -n eden

# Record the change cause (revision annotation)
kubectl annotate deployment eden-api kubernetes.io/change-cause="Updated to nginx:1.21" -n eden --overwrite

# Patch the rolling update strategy
kubectl patch deployment eden-api -n eden -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":2,"maxUnavailable":0}}}}'
```

**Explanation:** `set image` updates the container image, `annotate` writes the `kubernetes.io/change-cause` revision annotation, and `patch` sets `maxSurge: 2` / `maxUnavailable: 0`.

---

## Question 8 | Kustomize ConfigMap Generator

> Server: `ssh ckad9988`

```bash
# Modify kustomization.yaml
cat <<EOF >> /tmp/exam/course/8/kustomize/kustomization.yaml
secretGenerator:
- name: matrix-secret
  literals:
  - db-password=supersecret
generatorOptions:
  disableNameSuffixHash: true
EOF

# Apply the kustomization to the matrix namespace
kubectl kustomize /tmp/exam/course/8/kustomize | kubectl apply -n matrix -f -
```

**Explanation:** The `secretGenerator` creates `matrix-secret`; `disableNameSuffixHash: true` keeps the name without the random hash suffix so the exact name resolves.

---

## Question 9 | Init Container Failure Debug

> Server: `ssh ckad9988`

```bash
# Inspect why the init container fails (it runs 'exit 1')
kubectl describe pod stuck-pod -n cosmos

# Recreate the pod with a succeeding init command
kubectl get pod stuck-pod -n cosmos -o yaml > /tmp/exam/stuck.yaml
sed -i 's/exit 1/exit 0/g' /tmp/exam/stuck.yaml
kubectl replace --force -f /tmp/exam/stuck.yaml
```

**Explanation:** The init container intentionally exits with code 1. Changing the command to exit 0 lets it succeed so the pod reaches `Running`.

---

## Question 10 | Namespace Events Export

> Server: `ssh ckad9988`

```bash
kubectl get events -n zenith -o custom-columns=TYPE:.type,REASON:.reason,MESSAGE:.message > /tmp/exam/course/10/events.txt
```

**Explanation:** `custom-columns` produces the exact `TYPE`, `REASON`, `MESSAGE` headers required.

---

## Question 11 | Service Internal Traffic Policy

> Server: `ssh ckad9988`

```bash
cat <<EOF > /tmp/exam/course/11/check.sh
#!/bin/bash
kubectl port-forward svc/backend-api 9999:8080 -n genesis &
PF_PID=\$!
sleep 2
curl http://localhost:9999/health >> /tmp/exam/course/11/health.log
kill \$PF_PID
EOF
chmod +x /tmp/exam/course/11/check.sh
```

**Explanation:** The script port-forwards the `backend-api` service (`9999:8080`), curls `/health` and appends it to the log, then kills the port-forward.

---

## Question 12 | Projected ServiceAccount Token

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: projected-pod
  namespace: origin
  labels:
    app: projected
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    volumeMounts:
    - name: all-in-one
      mountPath: /var/run/projected
  volumes:
  - name: all-in-one
    projected:
      sources:
      - secret:
          name: my-secret
          items:
            - key: username
              path: username
      - configMap:
          name: my-config
      - downwardAPI:
          items:
            - path: "labels"
              fieldRef:
                fieldPath: metadata.labels
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
          audience: vault
EOF
```

**Explanation:** A single `projected` volume combines the Secret, ConfigMap, DownwardAPI and ServiceAccountToken sources, mounted at `/var/run/projected`.

---

## Question 13 | Secret stringData Entry

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: static-creds
  namespace: primal
type: Opaque
immutable: true
stringData:
  api-key: 12345ABC
EOF
```

**Explanation:** `immutable: true` prevents any future changes to the Secret's data.

---

## Question 14 | Pod with ReadOnlyRootFilesystem

> Server: `ssh ckad9988`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: ancient
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    securityContext:
      runAsNonRoot: true
      runAsUser: 1000
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
      capabilities:
        drop:
        - ALL
    volumeMounts:
    - name: cache-volume
      mountPath: /var/cache/nginx
    - name: run-volume
      mountPath: /var/run
  volumes:
  - name: cache-volume
    emptyDir: {}
  - name: run-volume
    emptyDir: {}
EOF
```

**Explanation:** The container-level securityContext hardens the pod; the `emptyDir` volumes at `/var/cache/nginx` and `/var/run` let nginx start with a read-only root filesystem.

---

## Question 15 | ClusterRole and ClusterRoleBinding

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitor-viewer
  labels:
    rbac.example.com/aggregate-to-monitor: "true"
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: aggregated-monitor
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.example.com/aggregate-to-monitor: "true"
rules: []
EOF
```

**Explanation:** The aggregation label on `monitor-viewer` matches the `aggregationRule` selector of `aggregated-monitor`, so its rules are inherited automatically.

---

## Question 16 | ResourceQuota for Namespace

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: priority-quota
  namespace: eden
spec:
  hard:
    pods: "5"
    requests.cpu: "2"
  scopeSelector:
    matchExpressions:
    - operator: In
      scopeName: PriorityClass
      values:
      - high-priority
EOF
```

**Explanation:** The quota limits pods to 5 and `requests.cpu` to 2, and only applies to pods with the `high-priority` PriorityClass via the `PriorityClass` scope selector (`operator: In`).

---

## Question 17 | NetworkPolicy Named Port

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-named-port
  namespace: matrix
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - port: api-port
      protocol: TCP
EOF
```

**Explanation:** The policy targets `role=backend` pods and allows TCP traffic on the named port `api-port` only from `role=frontend` pods in the same namespace.

---

## Question 18 | Ingress Default Backend

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cosmos-ingress
  namespace: cosmos
spec:
  ingressClassName: nginx
  rules:
  - host: cosmos.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: cosmos-svc
            port:
              number: 80
EOF
```

**Explanation:** Setting `ingressClassName: nginx` associates the Ingress with the nginx controller, and the backend port is corrected to `80`.

---

## Question 19 | Service Endpoint Inspection

> Server: `ssh ckad9977`

```bash
kubectl run dns-tester -n zenith --image=busybox:1.32 -- sleep 3600
echo "data-svc.ancient.svc.cluster.local" > /tmp/exam/course/19/fqdn.txt
```

**Explanation:** Cross-namespace service resolution uses the FQDN `<service>.<namespace>.svc.cluster.local`.

---

## Question 20 | Namespace Isolation NetworkPolicy

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: isolate-namespace
  namespace: nexus
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector: {}
  egress:
  - {}
EOF
```

**Explanation:** `podSelector: {}` selects all pods in `nexus`. `from: - podSelector: {}` admits traffic only from pods in the same namespace (blocking other namespaces), and `egress: - {}` permits all outbound traffic.
