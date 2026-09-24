#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=archive
DEP=plate-scanner

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in namespace $NS"; exit 1; }

echo "$json" | jq -e '.spec.replicas == 1 and (.status.readyReplicas // 0) >= 1' >/dev/null \
  || { echo "FAIL: Deployment $DEP must have 1 replica and it must be ready"; exit 1; }

echo "$json" | jq -e '
  .spec.template.spec as $s
  | [ $s.volumes[]? | select(.persistentVolumeClaim.claimName == "plate-archive") | .name ] as $v
  | [ $s.containers[]
      | select(.name == "scanner" and ((.image // "") | endswith("busybox:1.36")))
      | .volumeMounts[]?
      | select((.mountPath | rtrimstr("/")) == "/archive")
      | .name as $m
      | select(any($v[]; . == $m)) ]
  | length > 0' >/dev/null \
  || { echo "FAIL: container scanner (busybox:1.36) does not mount PVC plate-archive at /archive"; exit 1; }

echo "OK: Deployment $DEP mounts PVC plate-archive at /archive"
exit 0
