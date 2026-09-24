#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
present=$(kubectl -n dockhands get pods stevedore-1 stevedore-2 stevedore-3 lasher-1 lasher-2 clerk-1 -o name 2>/dev/null | wc -l)
[ "$present" -eq 6 ] || { echo "ERR: only $present of the 6 original pods exist (do not delete them)"; exit 1; }
left=$(kubectl -n dockhands get pods -l onboarding -o name 2>/dev/null | wc -l)
[ "$left" -eq 0 ] && { echo "OK: no pod carries the onboarding label"; exit 0; }
echo "ERR: $left pod(s) still have the onboarding label"; exit 1
