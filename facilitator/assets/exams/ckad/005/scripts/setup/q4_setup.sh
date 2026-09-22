#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace prowl --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: batch/v1
kind: CronJob
metadata:
  name: data-sync
  namespace: prowl
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sync
            image: busybox:1.36
            command: ["sh", "-c", "echo 'Syncing data...' && sleep 10"]
          restartPolicy: OnFailure
YAML
echo "Setup complete for Question 4"
exit 0
