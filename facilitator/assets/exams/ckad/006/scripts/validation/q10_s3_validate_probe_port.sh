#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deploy api-deploy -n rapids -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.port}' 2>/dev/null)
if [ "$v" = "8080" ]; then echo "Success: readiness probe port is 8080"; exit 0; else echo "Error: probe port is '$v', expected 8080"; exit 1; fi
