#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace spark --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/3
cat > /tmp/exam/course/3/job.yaml <<'EOF'
# Q3 - Job Template for Timeout Question
# Task: Add activeDeadlineSeconds to limit job execution time
---
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
  namespace: spark
spec:
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["sh", "-c", "echo 'Processing data...' && sleep 30 && echo 'Done'"]
      restartPolicy: Never
  backoffLimit: 2
EOF

echo "Setup complete for Question 3"
exit 0
