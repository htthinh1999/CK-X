#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace aurora --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl apply -f - >/dev/null 2>&1 <<'EOF' || true
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-data-pv
spec:
  # Same class a PVC gets by default on k3s, so a PVC without storageClassName
  # binds to this PV instead of local-path dynamically provisioning a new one.
  storageClassName: local-path
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/data/app
EOF
echo "Setup complete for Question 4"
exit 0
