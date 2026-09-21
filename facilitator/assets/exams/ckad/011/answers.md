# CKAD Simulation 9 — Answers

> Dojo Ryujin 🐲 — Ryujin des Profondeurs
>
> *「龍神は波を操る」 - Ryujin commands the waves*
>
> Original Questions: Adapted from [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises) by [@dgkanatsios](https://github.com/dgkanatsios).
>
> Paths use `/tmp/exam/course/N/...`. Everything runs on the single `ckad9999` host / one cluster.

---

## Question 1 | Helm Create Chart

```bash
mkdir -p /tmp/exam/course/1
cd /tmp/exam/course/1
helm create sea-app
```

---

## Question 2 | Helm Install with Custom Values

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install my-release bitnami/nginx -n tide --set replicaCount=2
```

---

## Question 3 | Helm Upgrade Release

```bash
# my-release must exist first (see Q2). Then upgrade it:
helm upgrade my-release bitnami/nginx -n tide --set replicaCount=3
```

---

## Question 4 | Helm Rollback

```bash
# Check current revision
helm history rollback-app -n wave

# Rollback to revision 1 (this creates a new, higher revision)
helm rollback rollback-app 1 -n wave
```

---

## Question 5 | PersistentVolume Creation

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

## Question 6 | PersistentVolumeClaim

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

## Question 7 | Pod with PVC

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

---

## Question 8 | Pod with nodeName

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

## Question 9 | Pod Lifecycle - Echo and Exit

```bash
# Create a Pod that echoes and exits (stays around as Succeeded)
kubectl run echo-pod -n current --image=busybox:1.36 --restart=Never -- /bin/sh -c 'echo "hello world"'

# Alternatively with --rm (auto-delete after completion)
# kubectl run echo-pod -n current --image=busybox:1.36 --restart=Never --rm -it -- /bin/sh -c 'echo "hello world"'
```

Using `--restart=Never` (without `--rm`) leaves the Pod in phase `Succeeded`, which satisfies both checks.

---

## Question 10 | Get Pod YAML

```bash
mkdir -p /tmp/exam/course/10

kubectl run inspect-pod --image=nginx:1.25 -n abyss

kubectl get pod inspect-pod -n abyss -o yaml > /tmp/exam/course/10/pod.yaml
```

---

## Question 11 | Describe Pod and Find Events

```bash
mkdir -p /tmp/exam/course/11

kubectl describe pod problem-pod -n pearl | sed -n '/^Events:/,$p' > /tmp/exam/course/11/events.txt
```

---

## Question 12 | Execute Command in Pod

```bash
mkdir -p /tmp/exam/course/12

kubectl run exec-pod --image=nginx:1.25 -n storm

kubectl wait --for=condition=Ready pod/exec-pod -n storm --timeout=60s

kubectl exec exec-pod -n storm -- hostname > /tmp/exam/course/12/hostname.txt
```

---

## Question 13 | Get Previous Container Logs

```bash
mkdir -p /tmp/exam/course/13

kubectl logs restart-pod -n harbor --previous > /tmp/exam/course/13/previous.txt
```

---

## Question 14 | Top Nodes

```bash
mkdir -p /tmp/exam/course/14

# If metrics-server is unavailable, redirect stderr too so the file is not empty:
kubectl top nodes > /tmp/exam/course/14/nodes.txt 2>&1
```

---

## Question 15 | ConfigMap from .env File

```bash
mkdir -p /tmp/exam/course/15

cat > /tmp/exam/course/15/config.env << 'EOF'
DB_HOST=localhost
DB_PORT=5432
EOF

kubectl create configmap env-config -n voyage --from-env-file=/tmp/exam/course/15/config.env
```

---

## Question 16 | Deployment Rollout to Specific Revision

```bash
kubectl rollout history deployment/web-deploy -n tide

kubectl rollout undo deployment/web-deploy -n tide --to-revision=2
```

---

## Question 17 | Check Rollout History Details

```bash
mkdir -p /tmp/exam/course/17

kubectl rollout history deployment/history-deploy -n wave --revision=3 > /tmp/exam/course/17/revision.txt
```

---

## Question 18 | Job with Perl Image

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

## Question 19 | Multi-Container Pod with Shared Volume

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

## Question 20 | Resource Utilization of Pods

```bash
mkdir -p /tmp/exam/course/20

# If metrics-server is unavailable, redirect stderr too so the file is not empty:
kubectl top pods -n storm > /tmp/exam/course/20/top-pods.txt 2>&1
```
