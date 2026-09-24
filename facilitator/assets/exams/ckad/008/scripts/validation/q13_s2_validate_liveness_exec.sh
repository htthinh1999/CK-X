#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

c=$(kubectl get pod liveness-pod -n stone -o jsonpath='{.spec.containers[0].livenessProbe.exec.command}' 2>/dev/null)
if [ -n "$c" ]; then echo "Success: exec liveness probe configured"; exit 0; else echo "Error: no exec liveness probe"; exit 1; fi
