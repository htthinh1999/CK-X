#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# count app containers + native sidecars (init containers with restartPolicy Always)
c=$(kubectl get pod adapter-pod -n zeus -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length')
c=${c:-0}
if [ "$c" -ge 2 ]; then echo "Success: $c containers"; exit 0; else echo "Error: found $c containers, expected >=2"; exit 1; fi
