#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace stronghold --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/20
cat > /tmp/exam/course/20/sidecar-pod.yaml <<'EOF'
# Complete this Pod spec to add a sidecar container
# The main container writes logs, the sidecar reads them via a shared volume
apiVersion: v1
kind: Pod
metadata:
  name: logger-app
  namespace: stronghold
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo \"$(date) - App running\" >> /var/log/app.log; sleep 5; done"]
    # TODO: Add volumeMount for shared-logs at /var/log
  # TODO: Add sidecar container named 'log-reader'
  #   image: busybox:1.36
  #   command: tail -f /var/log/app.log
  #   mount shared-logs at /var/log
  # TODO: Add shared volume 'shared-logs' of type emptyDir
EOF
echo "Setup complete for Question 20"
exit 0
