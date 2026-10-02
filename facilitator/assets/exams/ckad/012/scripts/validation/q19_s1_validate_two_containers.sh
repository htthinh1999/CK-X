#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# containers + native sidecars (init containers with restartPolicy: Always)
cnt=$(kubectl get pod logger-app -n stronghold -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length' 2>/dev/null)
cnt=${cnt:-0}
if [ "$cnt" -ge 2 ] 2>/dev/null; then echo "Success: pod has $cnt containers (incl. native sidecars)"; exit 0
else echo "Error: pod has fewer than 2 containers incl. native sidecars ($cnt)"; exit 1; fi
