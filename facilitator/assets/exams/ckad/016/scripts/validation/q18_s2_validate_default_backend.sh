#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
svc=$(kubectl get ingress default-ing -n surge -o jsonpath='{.spec.defaultBackend.service.name}' 2>/dev/null)
if [ "$svc" = "fallback-svc" ]; then echo "Success: defaultBackend service is fallback-svc"; exit 0; fi
echo "Error: defaultBackend service is '$svc', expected fallback-svc"; exit 1
