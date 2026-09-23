#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=timetable
D=/home/candidate/exam/q9

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf "$D"
mkdir -p "$D"

# Reset: remove every Job (and its Pods) from a previous run
kubectl -n "$NS" delete job timetable-build timetable-import timetable-import-dryrun timetable-sync timetable-export \
  --ignore-not-found --cascade=foreground --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete pods -l batch.kubernetes.io/job-name --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true

cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: batch/v1
kind: Job
metadata:
  name: timetable-import
  namespace: timetable
spec:
  backoffLimit: 1
  template:
    spec:
      restartPolicy: Never
      volumes:
      - name: feed
        emptyDir: {}
      initContainers:
      - name: verify-feed
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          echo "verifying timetable feed"
          [ -d /feed ] || exit 21
          [ -s /feed/timetable.csv ] || exit 23
          grep -q '^route,' /feed/timetable.csv || exit 25
          echo "feed ok"
        volumeMounts:
        - name: feed
          mountPath: /feed
      containers:
      - name: import
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          echo "importing timetable"
          wc -l /feed/timetable.csv || exit 64
          echo "import done"
        volumeMounts:
        - name: feed
          mountPath: /feed
---
apiVersion: batch/v1
kind: Job
metadata:
  name: timetable-import-dryrun
  namespace: timetable
spec:
  backoffLimit: 0
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: import
        image: busybox:1.36
        command: ["sh", "-c", "echo 'dry run: schema mismatch'; exit 2"]
---
apiVersion: batch/v1
kind: Job
metadata:
  name: timetable-sync
  namespace: timetable
spec:
  backoffLimit: 2
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: sync
        image: busybox:1.36
        command: ["sh", "-c", "echo 'sync complete: 412 trips'"]
---
apiVersion: batch/v1
kind: Job
metadata:
  name: timetable-export
  namespace: timetable
spec:
  backoffLimit: 3
  activeDeadlineSeconds: 15
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: export
        image: busybox:1.36
        command: ["sh", "-c", "echo 'exporting'; sleep 600"]
YAML

# Let the broken import reach its final (Failed) state; bounded wait
kubectl -n "$NS" wait --for=condition=Failed job/timetable-import --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 9"
exit 0
