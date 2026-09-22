# CKAD Simulation 17 — Answers

> Dojo Hachiman ⚔️ — *「八幡は戦略を練る」- Hachiman hones strategy*
>
> Adaptations for this simulator: paths `/opt/course/N/` and `./exam/course/N/` become `/tmp/exam/course/N/`; the registry is `localhost:5000`; each question runs on the server named in its `Server` line (`ssh` there and work with that server's only, default context).

---

## Question 1 | Pod Command and Args Override

> Server: `ssh ckad9999`

```bash
kubectl run entry-override -n fortress --image=nginx:alpine \
  --dry-run=client -o yaml --command -- sleep 3600 > /tmp/exam/course/1/pod.yaml
kubectl apply -f /tmp/exam/course/1/pod.yaml
```

`--command` populates the container `command` (entrypoint override); the trailing `3600` lands in `args`. Verify with `kubectl get pod entry-override -n fortress -o yaml`.

---

## Question 2 | ConfigMap as Init Script Volume

> Server: `ssh ckad9999`

```bash
kubectl create configmap init-script-cm -n fortress --from-literal=setup.sh='#!/bin/sh
echo "Initialization successful!" > /work-dir/index.html'
```

```yaml
# /tmp/exam/course/2/init-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-setup
  namespace: fortress
spec:
  initContainers:
  - name: init-setup
    image: busybox:1.36
    command: ["sh", "/scripts/setup.sh"]
    volumeMounts:
    - name: script-vol
      mountPath: /scripts
    - name: work-vol
      mountPath: /work-dir
  containers:
  - name: web-setup
    image: nginx:alpine
    volumeMounts:
    - name: work-vol
      mountPath: /usr/share/nginx/html
  volumes:
  - name: script-vol
    configMap:
      name: init-script-cm
  - name: work-vol
    emptyDir: {}
```

```bash
kubectl apply -f /tmp/exam/course/2/init-pod.yaml
```

---

## Question 3 | CronJob Scheduled Report

> Server: `ssh ckad9999`

```bash
kubectl create cronjob siege-report -n siege --image=busybox:1.36 \
  --schedule="30 * * * *" --dry-run=client -o yaml \
  -- /bin/sh -c "date; echo Hello from siege" > /tmp/exam/course/3/cronjob.yaml
# Add `timeZone: "Asia/Tokyo"` under spec:
```

```yaml
spec:
  schedule: "30 * * * *"
  timeZone: "Asia/Tokyo"
```

```bash
kubectl apply -f /tmp/exam/course/3/cronjob.yaml
```

`timeZone` is supported directly under `spec` since Kubernetes 1.27.

---

## Question 4 | Sidecar Process Monitor

> Server: `ssh ckad9999`

```yaml
# /tmp/exam/course/4/shared-pid.yaml
apiVersion: v1
kind: Pod
metadata:
  name: process-monitor
  namespace: bastion
spec:
  shareProcessNamespace: true
  containers:
  - name: nginx-app
    image: nginx:alpine
  - name: monitor-app
    image: busybox:1.36
    command: ["/bin/sh", "-c", "while true; do ps -ef; sleep 5; done"]
```

```bash
kubectl apply -f /tmp/exam/course/4/shared-pid.yaml
```

---

## Question 5 | Helm Release Upgrade (Atomic)

> Server: `ssh ckad9999`

```bash
helm upgrade battle-web /tmp/exam/course/5/battle-chart/ -n garrison \
  --atomic --timeout 1m --set replicaCount=3
```

`--atomic` rolls back automatically if the release does not become ready within `--timeout`. The upgrade sets `replicaCount=3`, so deployment `battle-web-battle-chart` scales to 3.

---

## Question 6 | Deployment with progressDeadlineSeconds

> Server: `ssh ckad9999`

```bash
kubectl create deployment citadel-guard -n citadel --image=nginx:1.24.0-alpine \
  --replicas=4 --dry-run=client -o yaml > /tmp/exam/course/6/deploy.yaml
# Add `progressDeadlineSeconds: 15` under spec and labels app=guard
```

```yaml
spec:
  replicas: 4
  progressDeadlineSeconds: 15
  selector:
    matchLabels:
      app: guard
  template:
    metadata:
      labels:
        app: guard
    spec:
      containers:
      - name: nginx
        image: nginx:1.24.0-alpine
```

```bash
kubectl apply -f /tmp/exam/course/6/deploy.yaml
```

---

## Question 7 | Blue-Green Service Switch

> Server: `ssh ckad9999`

```bash
kubectl create deployment api-server-green -n rampart \
  --image=nginx:1.25.0-alpine --replicas=2
# The above sets label app=api-server-green on the template.
kubectl patch svc api-svc -n rampart \
  -p '{"spec":{"selector":{"app":"api-server-green"}}}'
```

Leave `api-server-blue` untouched. The Service now selects the green pods.

---

## Question 8 | Kustomize Image + Replica Patch

> Server: `ssh ckad9988`

```yaml
# /tmp/exam/course/8/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
images:
- name: nginx
  newName: nginx
  newTag: 1.23.0-alpine
patches:
- target:
    kind: Deployment
    name: vanguard-web
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 5
```

```bash
kubectl kustomize /tmp/exam/course/8/ > /tmp/exam/course/8/kustomize-output.yaml
kubectl apply -f /tmp/exam/course/8/kustomize-output.yaml -n vanguard
```

---

## Question 9 | CrashLoopBackOff / OOMKilled Debug

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/9
kubectl get pod data-processor -n sentinel -o yaml > /tmp/exam/course/9/processor.yaml
# Edit resources.limits.memory to 256Mi, keep requests.memory 64Mi
vi /tmp/exam/course/9/processor.yaml
# Resource limits of a running Pod can't be edited in place: delete and recreate it
kubectl replace --force -f /tmp/exam/course/9/processor.yaml
```

```yaml
    resources:
      requests:
        memory: "64Mi"
      limits:
        memory: "256Mi"
```

The larger limit lets the stress workload run without being OOMKilled, so the pod reaches `Running`.

---

## Question 10 | Ephemeral Debug Container

> Server: `ssh ckad9988`

```bash
kubectl debug -it secure-app -n outpost --image=busybox:1.36 \
  --target=app -c debugger -- sh -c "sleep 3600"
```

`kubectl debug` injects an ephemeral container named `debugger`; `sleep 3600` keeps it running so the scoring script detects it.

---

## Question 11 | ResourceQuota Troubleshooting

> Server: `ssh ckad9988`

```bash
kubectl describe quota armory-quota -n armory
# Set pod requests to fit the quota (100m CPU / 128Mi mem) and scale to 3.
kubectl set resources deploy weapon-smith -n armory --requests=cpu=100m,memory=128Mi
kubectl scale deploy weapon-smith -n armory --replicas=3
```

With 100m×3 = 300m CPU and 128Mi×3 = 384Mi memory, the pods fit the `500m` CPU / `1Gi` memory quota.

---

## Question 12 | Downward API Env Vars

> Server: `ssh ckad9988`

```yaml
# /tmp/exam/course/12/downward.yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-aware
  namespace: fortress
spec:
  containers:
  - name: main
    image: busybox:1.36
    command: ["sleep", "3600"]
    resources:
      requests:
        cpu: "200m"
      limits:
        memory: "256Mi"
    env:
    - name: MY_CPU_REQUEST
      valueFrom:
        resourceFieldRef:
          containerName: main
          resource: requests.cpu
    - name: MY_MEM_LIMIT
      valueFrom:
        resourceFieldRef:
          containerName: main
          resource: limits.memory
```

```bash
kubectl apply -f /tmp/exam/course/12/downward.yaml
```

---

## Question 13 | ServiceAccount with Manual Token Mount

> Server: `ssh ckad9988`

```yaml
# /tmp/exam/course/13/sa-pod.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: stealth-sa
  namespace: siege
---
apiVersion: v1
kind: Pod
metadata:
  name: stealth-pod
  namespace: siege
spec:
  serviceAccountName: stealth-sa
  automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx:alpine
    volumeMounts:
    - name: custom-token
      mountPath: /var/run/secrets/custom-token
  volumes:
  - name: custom-token
    projected:
      sources:
      - serviceAccountToken:
          path: token
```

```bash
kubectl apply -f /tmp/exam/course/13/sa-pod.yaml
```

---

## Question 14 | SecurityContext + seccomp

> Server: `ssh ckad9988`

```yaml
# /tmp/exam/course/14/seccomp.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-workload
  namespace: bastion
spec:
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:alpine
```

```bash
kubectl apply -f /tmp/exam/course/14/seccomp.yaml
```

---

## Question 15 | Selective Secret Key Volume

> Server: `ssh ckad9977`

```yaml
# /tmp/exam/course/15/multi-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: citadel
type: Opaque
stringData:
  username: admin
  password: hachiman_rocks
---
apiVersion: v1
kind: Pod
metadata:
  name: db-consumer
  namespace: citadel
spec:
  containers:
  - name: main
    image: alpine:3.18
    command: ["sleep", "3600"]
    volumeMounts:
    - name: db-creds
      mountPath: /etc/db-creds
  volumes:
  - name: db-creds
    secret:
      secretName: db-credentials
      items:
      - key: password
        path: db-pass.txt
```

```bash
kubectl apply -f /tmp/exam/course/15/multi-secret.yaml
```

Only the `password` key is projected, mounted as `/etc/db-creds/db-pass.txt`.

---

## Question 16 | LimitRange Defaults

> Server: `ssh ckad9977`

```yaml
# /tmp/exam/course/16/limit-range.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: rampart-limits
  namespace: rampart
spec:
  limits:
  - type: Container
    default:
      memory: 512Mi
      cpu: 500m
    defaultRequest:
      memory: 256Mi
      cpu: 200m
---
apiVersion: v1
kind: Pod
metadata:
  name: default-pod
  namespace: rampart
spec:
  containers:
  - name: nginx
    image: nginx:alpine
```

```bash
kubectl apply -f /tmp/exam/course/16/limit-range.yaml
```

`default-pod` inherits `256Mi` memory request from the LimitRange.

---

## Question 17 | Ingress NetworkPolicy

> Server: `ssh ckad9977`

```yaml
# /tmp/exam/course/17/netpol.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: protect-db
  namespace: vanguard
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: backend
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: bastion
    ports:
    - protocol: TCP
      port: 5432
```

```bash
kubectl apply -f /tmp/exam/course/17/netpol.yaml
```

---

## Question 18 | Canary Ingress

> Server: `ssh ckad9977`

```yaml
# /tmp/exam/course/18/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: canary-ingress
  namespace: sentinel
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "20"
spec:
  ingressClassName: nginx
  rules:
  - host: sentinel.dojo.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: canary-svc
            port:
              number: 80
```

```bash
kubectl apply -f /tmp/exam/course/18/ingress.yaml
```

---

## Question 19 | Selectorless Service + Endpoints

> Server: `ssh ckad9977`

```yaml
# /tmp/exam/course/19/manual-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
  namespace: outpost
spec:
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
---
apiVersion: v1
kind: Endpoints
metadata:
  name: external-db
  namespace: outpost
subsets:
- addresses:
  - ip: 10.50.50.50
  ports:
  - port: 3306
    protocol: TCP
```

```bash
kubectl apply -f /tmp/exam/course/19/manual-svc.yaml
```

The Service has no selector, so the manually-created Endpoints (matching name) route to `10.50.50.50:3306`.

---

## Question 20 | CoreDNS Rewrite Rule

> Server: `ssh ckad9977`

```bash
kubectl get configmap coredns -n kube-system -o yaml > /tmp/exam/course/20/coredns.yaml
# Edit the Corefile block to add the rewrite line before `kubernetes`:
#   rewrite name exact hachiman.local hachiman.garrison.svc.cluster.local
kubectl apply -f /tmp/exam/course/20/coredns.yaml
```

Example Corefile fragment inside the ConfigMap:

```
.:53 {
    errors
    health
    rewrite name exact hachiman.local hachiman.garrison.svc.cluster.local
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
    }
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

The saved `/tmp/exam/course/20/coredns.yaml` contains the `rewrite name exact hachiman.local hachiman.garrison.svc.cluster.local` line. No CoreDNS pod restart is required.
