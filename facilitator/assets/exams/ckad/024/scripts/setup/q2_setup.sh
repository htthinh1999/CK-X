#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace beacon --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
rm -rf /home/candidate/exam/q2 && mkdir -p /home/candidate/exam/q2

# The student creates lamp-keeper; remove any leftover copy.
kubectl -n beacon delete pod lamp-keeper --ignore-not-found --wait=false >/dev/null 2>&1 || true

# Decoy pod sharing the tier=signal label; it completes (phase Succeeded), so a
# command that prints the phase of more than one pod gives the wrong output.
kubectl -n beacon apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: v1
kind: Pod
metadata:
  name: flare-check
  namespace: beacon
  labels:
    tier: signal
    role: selftest
spec:
  restartPolicy: Never
  containers:
    - name: flare
      image: busybox:1.36
      command: ["sh", "-c", "echo flare self-test ok"]
      resources:
        requests:
          cpu: 10m
          memory: 16Mi
        limits:
          cpu: 50m
          memory: 32Mi
YAML

echo "Setup complete for Question 2"
exit 0
