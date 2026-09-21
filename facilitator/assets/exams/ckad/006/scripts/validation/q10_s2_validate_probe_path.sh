#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy api-deploy -n rapids -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null)
if [ "$v" = "/ready" ]; then echo "Success: readiness probe path is /ready"; exit 0; else echo "Error: probe path is '$v', expected /ready"; exit 1; fi
