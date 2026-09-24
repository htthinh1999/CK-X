#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=mirror
D=reflector

img=$(kubectl -n "$NS" get deployment "$D" -o jsonpath='{.spec.template.spec.containers[?(@.name=="web")].image}' 2>/dev/null)
[ "$img" = "nginx:1.26" ] && { echo "OK: container web uses nginx:1.26"; exit 0; }
echo "ERR: container web image is '${img:-<missing>}', expected nginx:1.26"
exit 1
