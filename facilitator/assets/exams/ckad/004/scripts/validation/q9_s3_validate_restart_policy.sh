#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get job retry-job -n artemis -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null)
if [ "$v" = "Never" ]; then echo "Success: restartPolicy Never"; exit 0; else echo "Error: restartPolicy is '$v', expected Never"; exit 1; fi
