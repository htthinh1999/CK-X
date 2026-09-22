#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
all=$(kubectl -n dockhands get pods -l role=stevedore -o name 2>/dev/null | wc -l)
night=$(kubectl -n dockhands get pods -l role=stevedore,shift=night -o name 2>/dev/null | wc -l)
extra=$(kubectl -n dockhands get pods -l 'shift=night,role!=stevedore' -o name 2>/dev/null | wc -l)
[ "$all" -eq 3 ] && [ "$night" -eq 3 ] && [ "$extra" -eq 0 ] && { echo "OK: all 3 stevedore pods (and only those) have shift=night"; exit 0; }
echo "ERR: stevedore pods=$all with shift=night=$night, non-stevedore pods with shift=night=$extra"; exit 1
