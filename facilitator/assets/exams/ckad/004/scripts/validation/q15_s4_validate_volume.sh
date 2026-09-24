#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod multi-init -n poseidon -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
if [ "$v" = "workdir" ]; then echo "Success: shared volume workdir"; exit 0; else echo "Error: volume is '$v', expected workdir"; exit 1; fi
