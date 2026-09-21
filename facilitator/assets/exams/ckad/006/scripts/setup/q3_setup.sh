#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace marsh --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Pod
metadata:
  name: log-collector
  namespace: marsh
spec:
  containers:
    - name: collector
      image: bitnami/kubectl:latest
      command:
        - /bin/sh
        - -c
        - |
          while true; do
            echo "Attempting to list pods in namespace marsh..."
            kubectl get pods -n marsh 2>&1
            echo "---"
            sleep 30
          done
EOF
echo "Setup complete for Question 3"
exit 0
