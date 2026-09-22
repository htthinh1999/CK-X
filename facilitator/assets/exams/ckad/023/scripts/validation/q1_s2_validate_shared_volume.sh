#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
v=$(kubectl $CTX -n dev get pod sidecar-pod -o jsonpath='{.spec.volumes[?(@.emptyDir)].name}' 2>/dev/null)
m0=$(kubectl $CTX -n dev get pod sidecar-pod -o jsonpath='{.spec.containers[0].volumeMounts[*].name}' 2>/dev/null)
m1=$(kubectl $CTX -n dev get pod sidecar-pod -o jsonpath='{.spec.containers[1].volumeMounts[*].name}' 2>/dev/null)
for vol in $v; do
  if echo "$m0" | grep -qw "$vol" && echo "$m1" | grep -qw "$vol"; then echo "OK: shared emptyDir '$vol' mounted in both"; exit 0; fi
done
echo "ERR: no emptyDir volume mounted in both containers (vols=$v m0=$m0 m1=$m1)"; exit 1
