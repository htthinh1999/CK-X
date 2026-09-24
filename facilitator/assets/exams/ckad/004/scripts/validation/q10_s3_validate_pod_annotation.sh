#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment annotated-app -n olympus -o jsonpath='{.spec.template.metadata.annotations.prometheus\.io/scrape}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: pod template annotation correct"; exit 0; else echo "Error: prometheus.io/scrape is '$v', expected true"; exit 1; fi
