#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
d=$(kubectl get deploy api-deploy -n rapids -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.initialDelaySeconds}' 2>/dev/null)
p=$(kubectl get deploy api-deploy -n rapids -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.periodSeconds}' 2>/dev/null)
if [ "$d" = "5" ] && [ "$p" = "10" ]; then echo "Success: probe timing delay=5 period=10"; exit 0; else echo "Error: delay='$d' period='$p', expected 5/10"; exit 1; fi
