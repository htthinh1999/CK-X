#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
c=$(kubectl get pod secure-app -n hades -o jsonpath='{range .spec.volumes[?(@.emptyDir)]}{.name}{"\n"}{end}' 2>/dev/null | grep -c . || echo 0)
if [ "$c" -ge 3 ]; then echo "Success: $c emptyDir volumes"; exit 0; else echo "Error: found $c emptyDir volumes, expected >=3"; exit 1; fi
