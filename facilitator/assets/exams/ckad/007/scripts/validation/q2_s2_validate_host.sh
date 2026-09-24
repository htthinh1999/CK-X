#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get ingress api-routing -n lagoon -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$val" = "api.lagoon.local" ]; then echo "Success: host is api.lagoon.local"; exit 0; else echo "Error: host is '$val', expected api.lagoon.local"; exit 1; fi
