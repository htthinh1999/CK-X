#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get deployment secure-app -n fortress -o jsonpath='{.spec.template.spec.securityContext.runAsUser}' 2>/dev/null)
c=$(kubectl get deployment secure-app -n fortress -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [ "$p" = "10000" ] || [ "$c" = "10000" ]; then echo "Success: runAsUser=10000 set"; exit 0
else echo "Error: runAsUser incorrect (pod=$p, container=$c, expected 10000)"; exit 1; fi
