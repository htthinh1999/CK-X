#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# The haproxy ambassador (regular container or native sidecar: init container with
# restartPolicy Always) must mount ConfigMap haproxy-config so that
# /usr/local/etc/haproxy/haproxy.cfg exists: the file via subPath, or the whole directory.
m=$(kubectl get pod ambassador-pod -n melody -o json 2>/dev/null | jq -r '(.spec.volumes // []) as $vols
  | [.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][]
  | select(.image | test("haproxy")) | (.volumeMounts // [])[] | . as $m
  | select(any($vols[]; .name == $m.name and .configMap.name == "haproxy-config"))
  | select(($m.mountPath == "/usr/local/etc/haproxy/haproxy.cfg" and ($m.subPath // "") != "")
      or (($m.mountPath | rtrimstr("/")) == "/usr/local/etc/haproxy" and ($m.subPath // "") == ""))
  | $m.mountPath' 2>/dev/null | head -1)
if [ -n "$m" ]; then
  echo "Success: haproxy-config configmap mounted in the ambassador at $m"; exit 0
fi
echo "Error: haproxy-config configmap not mounted in the haproxy ambassador at /usr/local/etc/haproxy/haproxy.cfg"; exit 1
