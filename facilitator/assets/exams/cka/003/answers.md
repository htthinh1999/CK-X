# CKA Multi-Cluster Practice Lab — Answers

This lab spans **two clusters**. Connect to the instance named in each question
and select the matching context:

- `cluster1` → `ssh ckad9999`, then `kubectl config use-context k3d-cluster1`
- `cluster2` → `ssh ckad9988`, then `kubectl config use-context k3d-cluster2`

`kubectl config get-contexts` lists every context available from any server.

---

## Question 1 — Deployment `web` (cluster1 / alpha)

```bash
kubectl config use-context k3d-cluster1
kubectl -n alpha create deployment web --image=nginx:1.25 --replicas=3
kubectl -n alpha rollout status deployment/web
```

## Question 2 — ClusterIP Service `cache-svc` (cluster1 / alpha)

```bash
kubectl -n alpha create service clusterip cache-svc --tcp=6379:6379
kubectl -n alpha patch service cache-svc -p '{"spec":{"selector":{"app":"cache"}}}'
# or write the YAML directly with selector app=cache, port/targetPort 6379
```

## Question 3 — ConfigMap + Pod env (cluster1 / alpha)

```bash
kubectl -n alpha create configmap app-config --from-literal=APP_MODE=prod --from-literal=MAX=10
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-reader
  namespace: alpha
spec:
  containers:
    - name: main
      image: busybox:1.36
      command: ["sleep", "3600"]
      envFrom:
        - configMapRef:
            name: app-config
YAML
```

## Question 4 — Scale + rolling update (cluster1 / alpha)

```bash
kubectl -n alpha scale deployment payments --replicas=5
kubectl -n alpha patch deployment payments -p \
  '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":1,"maxSurge":1}}}}'
```

## Question 5 — RBAC (cluster1 / alpha)

```bash
kubectl -n alpha create serviceaccount deployer
kubectl -n alpha create role deployer-role --verb=get,list,create --resource=deployments.apps
kubectl -n alpha create rolebinding deployer-binding --role=deployer-role --serviceaccount=alpha:deployer
```

## Question 6 — Schedule with nodeSelector (cluster1 / alpha)

```bash
# The worker node is already labelled disk=ssd (see: kubectl get nodes --show-labels)
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pinned
  namespace: alpha
spec:
  nodeSelector:
    disk: ssd
  containers:
    - name: web
      image: nginx:1.25
YAML
```

## Question 7 — Fix the broken Deployment (cluster1 / alpha)

```bash
kubectl -n alpha set image deployment/legacy app=nginx:1.25
kubectl -n alpha rollout status deployment/legacy
```

## Question 8 — PVC + Pod mount (cluster2 / beta)

```bash
kubectl config use-context k3d-cluster2
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data
  namespace: beta
spec:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: writer
  namespace: beta
spec:
  containers:
    - name: main
      image: busybox:1.36
      command: ["sleep", "3600"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: data
YAML
```

## Question 9 — Secret + Pod env (cluster2 / beta)

```bash
kubectl -n beta create secret generic db-cred --from-literal=username=admin --from-literal=password='S3cret!'
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: db-client
  namespace: beta
spec:
  containers:
    - name: main
      image: busybox:1.36
      command: ["sleep", "3600"]
      envFrom:
        - secretRef:
            name: db-cred
YAML
```

## Question 10 — CronJob (cluster2 / beta)

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: report
  namespace: beta
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: report
              image: busybox:1.36
              command: ["sh", "-c", "echo report"]
YAML
```

## Question 11 — Default-deny NetworkPolicy (cluster2 / beta)

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: beta
spec:
  podSelector: {}
  policyTypes:
    - Ingress
YAML
```

## Question 12 — Deployment + NodePort (cluster2 / beta)

```bash
kubectl -n beta create deployment api --image=nginx:1.25 --replicas=2
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: api-np
  namespace: beta
spec:
  type: NodePort
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30081
YAML
```
