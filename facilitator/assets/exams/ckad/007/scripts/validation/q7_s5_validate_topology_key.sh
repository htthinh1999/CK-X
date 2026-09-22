#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment web-frontend -n coral -o jsonpath='{.spec.template.spec.affinity.podAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey}' 2>/dev/null | grep -q "kubernetes.io/hostname"; then echo "Success: topologyKey"; exit 0; else echo "Error: topologyKey - not found"; exit 1; fi
