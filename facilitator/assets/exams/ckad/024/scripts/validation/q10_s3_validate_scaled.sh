#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
spec=$(kubectl -n yard get deployment forklift -o jsonpath='{.spec.replicas}' 2>/dev/null)
ready=$(kubectl -n yard get deployment forklift -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${spec:-0}" -ge 2 ] 2>/dev/null && [ "${ready:-0}" -ge 2 ] 2>/dev/null && { echo "OK: forklift scaled to $spec replicas ($ready ready)"; exit 0; }
echo "ERR: forklift replicas=${spec:-0} ready=${ready:-0} (want >= 2)"; exit 1
