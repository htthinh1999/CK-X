#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get pod writer >/dev/null 2>&1 || { echo "ERR: pod writer not found"; exit 1; }
mp=$(kubectl $CTX -n beta get pod writer -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
cl=$(kubectl $CTX -n beta get pod writer -o jsonpath='{.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)
echo "$mp" | grep -q "/data" && echo "$cl" | grep -qw "data" && { echo "OK: writer mounts pvc data at /data"; exit 0; }
echo "ERR: mounts=$mp claim=$cl"; exit 1
