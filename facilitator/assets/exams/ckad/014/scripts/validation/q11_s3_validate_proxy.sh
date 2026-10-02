#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
pod=$(kubectl get pod legacy-app -n eclipse -o json 2>/dev/null)
# containers + native sidecars (init containers with restartPolicy: Always)
conts=$(echo "$pod" | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | "\(.name) \(.image)"' 2>/dev/null)
if ! echo "$conts" | grep -q "proxy haproxy:2.8-alpine"; then
  echo "Error: proxy container (proxy haproxy:2.8-alpine) not found"
  exit 1
fi
# proxy must mount ConfigMap haproxy-config so that /usr/local/etc/haproxy/haproxy.cfg exists:
# a directory mount at /usr/local/etc/haproxy, or the file itself via subPath haproxy.cfg
cfg=$(echo "$pod" | jq -r '(.spec.volumes // []) as $vols
  | [.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][]
  | select(.name == "proxy") | (.volumeMounts // [])[] | . as $m
  | select(any($vols[]; .name == $m.name and .configMap.name == "haproxy-config"
      and (.configMap.items == null or any(.configMap.items[]; .path == "haproxy.cfg"))))
  | select((($m.mountPath | rtrimstr("/")) == "/usr/local/etc/haproxy" and ($m.subPath // "") == "")
      or ($m.mountPath == "/usr/local/etc/haproxy/haproxy.cfg" and $m.subPath == "haproxy.cfg"))
  | $m.mountPath' 2>/dev/null)
if [ -n "$cfg" ]; then
  echo "Success: proxy container correct (proxy haproxy:2.8-alpine, ConfigMap haproxy-config mounted at $cfg)"
  exit 0
else
  echo "Error: proxy container does not mount ConfigMap haproxy-config at /usr/local/etc/haproxy"
  exit 1
fi
