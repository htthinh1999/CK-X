# CKAD Simulation 13 — Answers

> Dojo Fujin 🌬️ — *「風神は嵐を呼ぶ」- Fujin summons the storm*
>
> Paths use `/tmp/exam/course/N/...`. The image registry is the local `localhost:5000` registry started during setup on the Question 1 server. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | Kustomize Apply

> Server: `ssh ckad9988`

```bash
cd /tmp/exam/course/1
cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
configMapGenerator:
  - name: tornado-config
    literals:
      - WIND_SPEED=150mph
EOF
kubectl apply -k . -n tornado
```

**Explanation:** Create `kustomization.yaml` at `/tmp/exam/course/1/` defining the resource and `configMapGenerator`, then apply it to the `tornado` namespace with `kubectl apply -k`.

---

## Question 2 | LimitRange Configuration

> Server: `ssh ckad9977`

```bash
cat <<EOF > /tmp/exam/q2.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cyclone-limits
  namespace: cyclone
spec:
  limits:
  - type: Pod
    max:
      memory: "500Mi"
    min:
      memory: "100Mi"
  - type: Container
    default:
      cpu: "500m"
    defaultRequest:
      cpu: "200m"
EOF
kubectl apply -f /tmp/exam/q2.yaml
```

**Explanation:** Define a LimitRange with Pod min/max memory and Container default/defaultRequest CPU.

---

## Question 3 | Docker Image Build and Push

> Server: `ssh ckad9999`

```bash
cd /tmp/exam/course/3
docker build -t localhost:5000/fujin-api:v2 .
docker push localhost:5000/fujin-api:v2
```

**Explanation:** Build the container image from the provided Dockerfile and tag it appropriately, then push it to the local registry at `localhost:5000` (started by the setup script). Verify with `curl -s http://localhost:5000/v2/fujin-api/tags/list`.

---

## Question 4 | OOMKilled Pod Troubleshooting

> Server: `ssh ckad9988`

```bash
kubectl get pod memory-hog -n mistral -o yaml > /tmp/exam/hog.yaml
# Edit hog.yaml: set spec.containers[0].resources.limits.memory to 256Mi (keep request 64Mi)
kubectl replace --force -f /tmp/exam/hog.yaml
```

**Explanation:** Since it is crashing with OOMKilled, increase the container memory limit to `256Mi`, keep the request at `64Mi`, and force-replace.

---

## Question 5 | Disable Default ServiceAccount Automount

> Server: `ssh ckad9977`

```bash
kubectl get pod zephyr-api -n zephyr -o yaml > /tmp/exam/q5.yaml
# Add automountServiceAccountToken: false under spec
kubectl replace --force -f /tmp/exam/q5.yaml
```

**Explanation:** Set `automountServiceAccountToken: false` at the Pod spec level and recreate the pod.

---

## Question 6 | Sidecar Logging Container

> Server: `ssh ckad9999`

```bash
kubectl get pod wind-logger -n gale -o yaml > /tmp/exam/wind.yaml
# Edit wind.yaml to add the adapter container
```

```yaml
# Add this under spec.containers:
  - name: adapter
    image: busybox:1.31.1
    command: ["sh", "-c", "tail -f /var/log/wind.log | sed 's/^/[WIND-LOG] /'"]
    volumeMounts:
    - name: logs
      mountPath: /var/log
```

```bash
kubectl replace --force -f /tmp/exam/wind.yaml
```

**Explanation:** Extract the pod YAML, add the `adapter` container sharing the same `logs` volume mounted at `/var/log`, then force-replace the pod (container changes require recreation).

---

## Question 7 | Top Memory-Consuming Pods

> Server: `ssh ckad9988`

```bash
kubectl top pods -n sirocco --sort-by=memory
# Write the top 3 pod names (highest -> lowest) to the file
kubectl top pods -n sirocco --sort-by=memory --no-headers | head -n 3 | awk '{print $1}' > /tmp/exam/course/7/top-pods.txt
```

**Explanation:** Use `kubectl top pods --sort-by=memory` to find the pods consuming the most memory and write the top 3 names, one per line, to `/tmp/exam/course/7/top-pods.txt`.

---

## Question 8 | Egress NetworkPolicy for DNS

> Server: `ssh ckad9977`

```bash
cat <<EOF > /tmp/exam/q8.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: typhoon
spec:
  podSelector:
    matchLabels:
      role: worker
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
EOF
kubectl apply -f /tmp/exam/q8.yaml
```

**Explanation:** Egress policy matching `role: worker`, allowing only TCP/UDP port 53. Because an egress rule is defined, all other egress is denied.

---

## Question 9 | Liveness and Readiness Probes

> Server: `ssh ckad9988`

```bash
cat <<EOF > /tmp/exam/q9.yaml
apiVersion: v1
kind: Pod
metadata:
  name: monsoon-checker
  namespace: monsoon
spec:
  containers:
  - name: checker
    image: busybox:1.31.1
    command: ["sh", "-c", "touch /tmp/ready && sleep 3600"]
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
kubectl apply -f /tmp/exam/q9.yaml
```

**Explanation:** Define a pod with an `exec` readiness probe running `cat /tmp/ready`, with initial delay 5s and period 10s.

---

## Question 10 | Batch Job Processing

> Server: `ssh ckad9999`

```bash
kubectl create job storm-processor -n breeze --image=busybox:1.31.1 --dry-run=client -o yaml -- sh -c 'sleep 2; echo "Processing storm data"' > /tmp/exam/job.yaml
# Edit job.yaml to add completions and parallelism
```

```yaml
# Add under spec:
  completions: 6
  parallelism: 3
```

```bash
kubectl apply -f /tmp/exam/job.yaml
```

**Explanation:** Create a Job with `completions: 6` and `parallelism: 3` in the spec.

---

## Question 11 | Secret from File

> Server: `ssh ckad9988`

```bash
kubectl create secret generic gale-secret -n gale --from-literal=password.txt=super-secret-wind
cat <<EOF > /tmp/exam/q11.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-reader
  namespace: gale
spec:
  containers:
  - name: reader
    image: alpine:3.14
    command: ["sleep", "3600"]
    volumeMounts:
    - name: sec-vol
      mountPath: /etc/secrets/password.txt
      subPath: password.txt
  volumes:
  - name: sec-vol
    secret:
      secretName: gale-secret
EOF
kubectl apply -f /tmp/exam/q11.yaml
```

**Explanation:** Create the secret, then define a pod mounting only `password.txt` via `subPath` so the rest of `/etc/secrets` is untouched.

---

## Question 12 | Ingress with Path Routing

> Server: `ssh ckad9977`

```bash
cat <<EOF > /tmp/exam/q12.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tornado-ingress
  namespace: tornado
spec:
  rules:
  - host: tornado.dojo.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 8080
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
EOF
kubectl apply -f /tmp/exam/q12.yaml
```

**Explanation:** Standard Ingress mapping `/api` and `/web` paths to backend services for host `tornado.dojo.com`.

---

## Question 13 | Fix Deployment CrashLoopBackOff

> Server: `ssh ckad9999`

```bash
kubectl get deployment tempest-app -n tempest -o yaml > /tmp/exam/dep.yaml
# Extract the pod template and create /tmp/exam/course/13/pod.yaml
```

```yaml
# /tmp/exam/course/13/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: tempest-debug
  namespace: tempest
spec:
  containers:
  - name: main
    image: nginx:1.22
    command: ['sleep', '3600']
    ports:
    - containerPort: 80
    env:
    - name: WIND_FORCE
      value: "high"
```

```bash
kubectl apply -f /tmp/exam/course/13/pod.yaml
```

**Explanation:** Extract the template from the deployment and wrap it in a Pod definition, changing only the container command to `['sleep', '3600']`. Save the manifest at `/tmp/exam/course/13/pod.yaml`.

---

## Question 14 | Role and RoleBinding

> Server: `ssh ckad9988`

```bash
kubectl create role breeze-manager -n breeze \
  --verb=create,delete,list,watch \
  --resource=deployments.apps,statefulsets.apps
kubectl create rolebinding breeze-manager-binding -n breeze \
  --role=breeze-manager --serviceaccount=breeze:breeze-admin
```

**Explanation:** Use imperative commands to create the Role (verbs on `deployments`/`statefulsets` in the `apps` group) and bind it to the existing `breeze-admin` ServiceAccount.

---

## Question 15 | Helm Release Upgrade

> Server: `ssh ckad9999`

```bash
helm upgrade storm-app /tmp/exam/course/15/storm-chart -n typhoon --set replicaCount=3 --set image.tag=v2.0.0
```

**Explanation:** Upgrade the helm release using `--set` to override `replicaCount` and `image.tag`.

---

## Question 16 | Pod with Volume and SecurityContext

> Server: `ssh ckad9988`

```bash
cat <<EOF > /tmp/exam/q16.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-storage
  namespace: tempest
spec:
  securityContext:
    fsGroup: 2000
  containers:
  - name: storage
    image: nginx:1.23.1
EOF
kubectl apply -f /tmp/exam/q16.yaml
```

**Explanation:** Set `fsGroup: 2000` in the pod-level security context.

---

## Question 17 | Rolling Update Strategy

> Server: `ssh ckad9999`

```bash
kubectl patch deployment cyclone-web -n cyclone -p '{"spec":{"revisionHistoryLimit":2}}'
kubectl set image deployment/cyclone-web -n cyclone web=nginx:1.23.1
```

**Explanation:** Patch the `revisionHistoryLimit` first, then trigger a rolling update by changing the image.

---

## Question 18 | Headless Service for StatefulSet

> Server: `ssh ckad9977`

```bash
kubectl create service clusterip mistral-db-headless -n mistral \
  --clusterip="None" --tcp=3306:3306 --dry-run=client -o yaml > /tmp/exam/svc.yaml
# Edit selector to match app: mistral-db
kubectl apply -f /tmp/exam/svc.yaml
```

Resulting manifest:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mistral-db-headless
  namespace: mistral
spec:
  clusterIP: None
  selector:
    app: mistral-db
  ports:
  - port: 3306
    targetPort: 3306
```

**Explanation:** A headless service sets `clusterIP: None`; set the selector to target the StatefulSet pods (`app: mistral-db`).

---

## Question 19 | Blue-Green Deployment Switch

> Server: `ssh ckad9999`

```bash
kubectl patch svc zephyr-svc -n zephyr -p '{"spec":{"selector":{"version":"green"}}}'
```

**Explanation:** Patching the service selector routes traffic to the pods with label `version: green`.

---

## Question 20 | Debug Service Connectivity

> Server: `ssh ckad9977`

```bash
kubectl exec sirocco-app -n sirocco -- env | grep SIROCCO_BACKEND
echo "SIROCCO_BACKEND_SERVICE_HOST" > /tmp/exam/course/20/svc-env.txt
```

**Explanation:** Kubernetes injects `<SERVICE_NAME>_SERVICE_HOST` for services that existed when the pod started. The variable holding the `sirocco-backend` IP is `SIROCCO_BACKEND_SERVICE_HOST`. Write that exact name to the file.
