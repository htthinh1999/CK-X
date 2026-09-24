# CKAD Simulation 9 — Answers

> Dojo Ryujin 🐲 — Ryujin des Profondeurs
>
> *「龍神は波を操る」 - Ryujin commands the waves*
>
> Original Questions: Adapted from [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises) by [@dgkanatsios](https://github.com/dgkanatsios).
>
> Paths use `/tmp/exam/course/N/...`. Each question runs on the server shown under its heading: `ssh` to that host and use its default context (one cluster per host).

---

## Question 1 | ConfigMap from .env File

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/1

cat > /tmp/exam/course/1/config.env << 'EOF'
DB_HOST=localhost
DB_PORT=5432
EOF

kubectl create configmap env-config -n voyage --from-env-file=/tmp/exam/course/1/config.env
```

---

## Question 2 | Pod with nodeName

> Server: `ssh ckad9988`

```bash
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: direct-pod
  namespace: coral
spec:
  nodeName: $NODE
  containers:
  - name: nginx
    image: nginx:1.25
EOF
```

---

## Question 3 | Deployment Rollout to Specific Revision

> Server: `ssh ckad9977`

```bash
kubectl rollout history deployment/web-deploy -n tide

kubectl rollout undo deployment/web-deploy -n tide --to-revision=2
```

---

## Question 4 | Pod Lifecycle - Echo and Exit

> Server: `ssh ckad9988`

```bash
# Create a Pod that echoes and exits (stays around as Succeeded)
kubectl run echo-pod -n current --image=busybox:1.36 --restart=Never -- /bin/sh -c 'echo "hello world"'

# Alternatively with --rm (auto-delete after completion)
# kubectl run echo-pod -n current --image=busybox:1.36 --restart=Never --rm -it -- /bin/sh -c 'echo "hello world"'
```

Using `--restart=Never` (without `--rm`) leaves the Pod in phase `Succeeded`, which satisfies both checks.

---

## Question 5 | Check Rollout History Details

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/5

kubectl rollout history deployment/history-deploy -n wave --revision=3 > /tmp/exam/course/5/revision.txt
```

---

## Question 6 | Get Pod YAML

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/6

kubectl run inspect-pod --image=nginx:1.25 -n abyss

kubectl get pod inspect-pod -n abyss -o yaml > /tmp/exam/course/6/pod.yaml
```

---

## Question 7 | Helm Create Chart

> Server: `ssh ckad9999`

```bash
mkdir -p /tmp/exam/course/7
cd /tmp/exam/course/7
helm create sea-app
```

---

## Question 8 | Describe Pod and Find Events

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/8

kubectl describe pod problem-pod -n pearl | sed -n '/^Events:/,$p' > /tmp/exam/course/8/events.txt
```

---

## Question 9 | Job with Perl Image

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: pi-job
  namespace: coral
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(100)"]
      restartPolicy: Never
  backoffLimit: 4
EOF

# Or with kubectl create job:
# kubectl create job pi-job -n coral --image=perl:5.34 -- perl -Mbignum=bpi -wle 'print bpi(100)'
```

---

## Question 10 | Helm Install with Custom Values

> Server: `ssh ckad9999`

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install my-release bitnami/nginx -n tide --set replicaCount=2
```

---

## Question 11 | Multi-Container Pod with Shared Volume

> Server: `ssh ckad9977`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-pod
  namespace: abyss
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args: ["while true; do echo \"\$(date)\" >> /logs/app.log; sleep 5; done"]
    volumeMounts:
    - name: log-volume
      mountPath: /logs
  - name: sidecar
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args: ["tail -f /logs/app.log"]
    volumeMounts:
    - name: log-volume
      mountPath: /logs
  volumes:
  - name: log-volume
    emptyDir: {}
EOF
```

---

## Question 12 | Helm Upgrade Release

> Server: `ssh ckad9999`

```bash
# my-release must exist first (see Q10). Then upgrade it:
helm upgrade my-release bitnami/nginx -n tide --set replicaCount=3
```

---

## Question 13 | Execute Command in Pod

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/13

kubectl run exec-pod --image=nginx:1.25 -n storm

kubectl wait --for=condition=Ready pod/exec-pod -n storm --timeout=60s

kubectl exec exec-pod -n storm -- hostname > /tmp/exam/course/13/hostname.txt
```

---

## Question 14 | Helm Rollback

> Server: `ssh ckad9999`

```bash
# Check current revision
helm history rollback-app -n wave

# Rollback to revision 1 (this creates a new, higher revision)
helm rollback rollback-app 1 -n wave
```

---

## Question 15 | Get Previous Container Logs

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/15

kubectl logs restart-pod -n harbor --previous > /tmp/exam/course/15/previous.txt
```

---

## Question 16 | PersistentVolume Creation

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sea-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /data/sea
EOF
```

---

## Question 17 | Resource Utilization of Pods

> Server: `ssh ckad9977`

```bash
mkdir -p /tmp/exam/course/17

# If metrics-server is unavailable, redirect stderr too so the file is not empty:
kubectl top pods -n storm > /tmp/exam/course/17/top-pods.txt 2>&1
```

---

## Question 18 | PersistentVolumeClaim

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sea-pvc
  namespace: depths
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 2Gi
EOF
```

---

## Question 19 | Top Nodes

> Server: `ssh ckad9988`

```bash
mkdir -p /tmp/exam/course/19

# If metrics-server is unavailable, redirect stderr too so the file is not empty:
kubectl top nodes > /tmp/exam/course/19/nodes.txt 2>&1
```

---

## Question 20 | Pod with PVC

> Server: `ssh ckad9999`

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
  namespace: depths
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: data-volume
      mountPath: /data
  volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: sea-pvc
EOF
```
