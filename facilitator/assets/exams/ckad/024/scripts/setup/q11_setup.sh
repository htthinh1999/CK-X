#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace winch --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start clean: a sidecar added earlier by 'kubectl patch' would survive a plain re-apply.
kubectl -n winch delete deployment hoist-controller --ignore-not-found --cascade=foreground --wait=true --timeout=60s >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q11 && mkdir -p /home/candidate/exam/q11
cat > /home/candidate/exam/q11/hoist-controller.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hoist-controller
  namespace: winch
  labels:
    app: hoist-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hoist-controller
  template:
    metadata:
      labels:
        app: hoist-controller
    spec:
      terminationGracePeriodSeconds: 5
      volumes:
        - name: hoist-logs
          emptyDir: {}
      containers:
        - name: hoist
          image: busybox:1.36
          command:
            - sh
            - -c
            - |
              while true; do
                echo "$(date -u +%H:%M:%S) hoist cycle complete load=ok" >> /var/log/hoist/cycles.log
                sleep 3
              done
          volumeMounts:
            - name: hoist-logs
              mountPath: /var/log/hoist
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 50m
              memory: 32Mi
YAML

kubectl apply -f /home/candidate/exam/q11/hoist-controller.yaml || true

echo "Setup complete for Question 11"
exit 0
