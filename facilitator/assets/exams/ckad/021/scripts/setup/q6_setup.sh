#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace shield --dry-run=client -o yaml | kubectl apply -f - || true
kubectl apply -f - <<'YAML'
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-cj
  namespace: shield
spec:
  schedule: "*/10 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: busybox
            command: ["echo", "backup"]
          restartPolicy: OnFailure
YAML
echo "Setup complete for Question 6"
exit 0
