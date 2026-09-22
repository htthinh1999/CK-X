# CKAD Simulation 11 — Answers

> Dojo Amaterasu ☀️ — 「天照は光を導く」 Amaterasu guides the light
>
> **Total Score**: 104 points | **Passing Score**: ~66% (69 points)

All file paths use the CK-X workspace `/tmp/exam/course/...`. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | Build Container Image and Save as Tarball (6 points)

> Server: `ssh ckad9999`

```bash
# Build the image
docker build -t solar-app:1.0 /tmp/exam/course/1/image/

# Verify
docker images solar-app:1.0

# Save as tarball
docker save -o /tmp/exam/course/1/solar-app.tar solar-app:1.0

# Verify
ls -lh /tmp/exam/course/1/solar-app.tar
```

---

## Question 2 | Create Deployment with Labels and Annotations (4 points)

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-app
  namespace: solar
  annotations:
    kubernetes.io/change-cause: "initial deployment"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
      tier: web
  template:
    metadata:
      labels:
        app: frontend
        tier: web
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
EOF

kubectl get deploy frontend-app -n solar
```

---

## Question 3 | Sidecar Container with Shared Volume (6 points)

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: web-with-sidecar
  namespace: corona
spec:
  volumes:
    - name: log-volume
      emptyDir: {}
  containers:
    - name: app
      image: nginx:1.25
      volumeMounts:
        - name: log-volume
          mountPath: /var/log/nginx
    - name: log-shipper
      image: busybox:1.36
      command: ["/bin/sh", "-c", "tail -f /var/log/nginx/access.log 2>/dev/null || sleep 3600"]
      volumeMounts:
        - name: log-volume
          mountPath: /var/log/nginx
EOF

kubectl get pod web-with-sidecar -n corona
```

---

## Question 4 | Create PVC and Mount in Pod (6 points)

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data-pvc
  namespace: aurora
spec:
  storageClassName: local-path   # same class as app-data-pv (also the k3s default)
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
EOF
# local-path uses WaitForFirstConsumer: the PVC stays Pending until data-pod is
# scheduled, then binds to app-data-pv.

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
  namespace: aurora
spec:
  containers:
    - name: web
      image: nginx:1.25
      volumeMounts:
        - name: data-vol
          mountPath: /usr/share/nginx/html
  volumes:
    - name: data-vol
      persistentVolumeClaim:
        claimName: app-data-pvc
EOF

kubectl get pvc app-data-pvc -n aurora   # VOLUME column shows app-data-pv once the pod runs
kubectl get pod data-pod -n aurora
```

---

## Question 5 | Blue/Green Deployment (8 points)

> Server: `ssh ckad9999`

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
  namespace: flare
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
      version: green
  template:
    metadata:
      labels:
        app: webapp
        version: green
    spec:
      containers:
        - name: web
          image: nginx:1.26
          ports:
            - containerPort: 80
EOF

kubectl rollout status deploy app-green -n flare

# Switch service to green
kubectl patch svc webapp-svc -n flare -p '{"spec":{"selector":{"app":"webapp","version":"green"}}}'

# Scale down blue
kubectl scale deploy app-blue -n flare --replicas=0

kubectl get endpoints webapp-svc -n flare
```

---

## Question 6 | Configure Rolling Update Strategy (6 points)

> Server: `ssh ckad9999`

```bash
# Patch the strategy
kubectl patch deploy api-app -n dawn -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'

# Update image
kubectl set image deploy/api-app api=nginx:1.26 -n dawn

kubectl rollout status deploy api-app -n dawn
kubectl get deploy api-app -n dawn -o jsonpath='{.spec.strategy}'
```

(You may also `kubectl edit deploy api-app -n dawn` and set the same fields.)

---

## Question 7 | Deploy with Kustomize (6 points)

> Server: `ssh ckad9988`

Create `/tmp/exam/course/7/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml

namePrefix: prod-

patches:
  - target:
      kind: Deployment
      name: web-app
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 3
```

```bash
kubectl kustomize /tmp/exam/course/7/
kubectl apply -k /tmp/exam/course/7/

kubectl get deploy prod-web-app -n zenith
kubectl get svc prod-web-svc -n zenith
```

---

## Question 8 | Helm Upgrade with Custom Values (4 points)

> Server: `ssh ckad9988`

```bash
helm get values web-release -n radiance

helm upgrade web-release bitnami/nginx -n radiance --set replicaCount=3 --reuse-values

helm list -n radiance -f web-release
helm history web-release -n radiance
```

---

## Question 9 | Add Startup Probe (4 points)

> Server: `ssh ckad9988`

```bash
kubectl edit deploy slow-app -n eclipse
```

Add the startup probe to the container named `app`:

```yaml
spec:
  template:
    spec:
      containers:
        - name: app
          startupProbe:
            httpGet:
              path: /healthz
              port: 8080
            failureThreshold: 30
            periodSeconds: 10
```

```bash
kubectl rollout status deploy slow-app -n eclipse
```

---

## Question 10 | Troubleshoot Pending Pod (6 points)

> Server: `ssh ckad9999`

```bash
# Identify the issue
kubectl describe pod stuck-pod -n solar
# Events show the node affinity/selector didn't match; nodeSelector key is disktype

# Save the reason
echo "disktype" > /tmp/exam/course/10/pending-reason.txt

# Fix (Option A): remove the nodeSelector and recreate
kubectl get pod stuck-pod -n solar -o yaml > /tmp/stuck-pod.yaml
# edit /tmp/stuck-pod.yaml to delete the nodeSelector block, then:
kubectl delete pod stuck-pod -n solar
kubectl apply -f /tmp/stuck-pod.yaml

# Fix (Option B): label a node to match
# kubectl label node <node-name> disktype=ssd

kubectl get pod stuck-pod -n solar
```

---

## Question 11 | Extract Logs from Multi-container Pod (4 points)

> Server: `ssh ckad9988`

```bash
kubectl logs multi-logger -n corona -c sidecar --tail=20 > /tmp/exam/course/11/sidecar-logs.txt

cat /tmp/exam/course/11/sidecar-logs.txt
```

---

## Question 12 | Discover and Use Custom Resource Definition (6 points)

> Server: `ssh ckad9988`

```bash
kubectl get crd | grep backup
# backups.ckad.example.com

echo "ckad.example.com" > /tmp/exam/course/12/crd-group.txt

kubectl apply -f - <<EOF
apiVersion: ckad.example.com/v1
kind: Backup
metadata:
  name: daily-backup
  namespace: aurora
spec:
  schedule: "0 2 * * *"
  retentionDays: 30
  storageLocation: "s3://backups/daily"
EOF

kubectl get backup daily-backup -n aurora
```

---

## Question 13 | Create TLS Secret (4 points)

> Server: `ssh ckad9988`

```bash
kubectl create secret tls web-tls \
  --cert=/tmp/exam/course/13/tls.crt \
  --key=/tmp/exam/course/13/tls.key \
  -n flare

kubectl get secret web-tls -n flare
```

---

## Question 14 | Harden Deployment with SecurityContext (4 points)

> Server: `ssh ckad9988`

```bash
kubectl edit deploy hardened-app -n dawn
```

Add the security contexts:

```yaml
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
      containers:
        - name: app
          securityContext:
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - ALL
```

```bash
kubectl rollout status deploy hardened-app -n dawn
```

Note: the base `nginx:1.25` image will not start with `runAsNonRoot`/`readOnlyRootFilesystem`. If the rollout does not become available, keep the security fields but adjust so a pod can run (e.g. use an image/command that runs as non-root and tolerates a read-only rootfs, such as adding a writable `emptyDir` for required paths). The verification checks the securityContext fields and that the Deployment has at least one available replica.

---

## Question 15 | ServiceAccount with RBAC and Verification (6 points)

> Server: `ssh ckad9977`

```bash
kubectl create sa deploy-sa -n zenith

kubectl create role deploy-role -n zenith \
  --verb=get,list,create,update \
  --resource=deployments

kubectl create rolebinding deploy-rb -n zenith \
  --role=deploy-role \
  --serviceaccount=zenith:deploy-sa

kubectl auth can-i list deployments \
  --as=system:serviceaccount:zenith:deploy-sa -n zenith \
  > /tmp/exam/course/15/auth-check.txt

cat /tmp/exam/course/15/auth-check.txt
```

---

## Question 16 | ConfigMap from env-file (4 points)

> Server: `ssh ckad9977`

```bash
kubectl create configmap app-config --from-env-file=/tmp/exam/course/16/app.env -n eclipse

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
  namespace: eclipse
spec:
  containers:
    - name: web
      image: nginx:1.25
      envFrom:
        - configMapRef:
            name: app-config
EOF

kubectl exec config-pod -n eclipse -- env | grep APP_
```

---

## Question 17 | Create docker-registry Secret (4 points)

> Server: `ssh ckad9977`

```bash
kubectl create secret docker-registry registry-creds \
  --docker-server=registry.example.com \
  --docker-username=admin \
  --docker-password=s3cur3P@ss \
  -n radiance

kubectl get secret registry-creds -n radiance -o jsonpath='{.type}'
```

---

## Question 18 | NetworkPolicy with ipBlock (6 points)

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow
  namespace: sunbeam
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend
        - ipBlock:
            cidr: 10.0.0.0/24
      ports:
        - protocol: TCP
          port: 80
EOF

kubectl describe networkpolicy api-allow -n sunbeam
```

---

## Question 19 | Ingress with TLS Termination (6 points)

> Server: `ssh ckad9977`

```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  namespace: solstice
spec:
  tls:
    - hosts:
        - secure.example.com
      secretName: secure-tls
  rules:
    - host: secure.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: secure-svc
                port:
                  number: 443
EOF

kubectl describe ingress secure-ingress -n solstice
```

---

## Question 20 | Fix Service and Verify DNS Resolution (4 points)

> Server: `ssh ckad9977`

```bash
kubectl get endpoints dns-svc -n sunbeam
# No endpoints — selector is wrong

kubectl patch svc dns-svc -n sunbeam -p '{"spec":{"selector":{"app":"dns-app"}}}'

kubectl get endpoints dns-svc -n sunbeam

kubectl run tmp-dns --rm -i --restart=Never --image=busybox:1.36 -n sunbeam \
  -- nslookup dns-svc.sunbeam.svc.cluster.local > /tmp/exam/course/20/dns-output.txt

cat /tmp/exam/course/20/dns-output.txt
```
