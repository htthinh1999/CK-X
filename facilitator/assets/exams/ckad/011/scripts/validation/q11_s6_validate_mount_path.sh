#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
pod=$(kubectl get pod sidecar-pod -n abyss -o json 2>/dev/null)
for c in app sidecar; do
  # look the container up by name (regular container or native sidecar)
  mp=$(echo "$pod" | jq -r --arg c "$c" '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == $c) | (.volumeMounts // [])[] | .mountPath | rtrimstr("/")' 2>/dev/null)
  if ! echo "$mp" | grep -qx "/logs"; then
    echo "Error: container $c has no volume mounted at /logs"
    exit 1
  fi
done
echo "Success: volume mounted at /logs in app and sidecar"
exit 0
