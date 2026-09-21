#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

mem=$(kubectl get quota cliff-quota -n cliff -o jsonpath='{.spec.hard.memory}' 2>/dev/null)
meml=$(kubectl get quota cliff-quota -n cliff -o jsonpath='{.spec.hard.limits\.memory}' 2>/dev/null)
if [ "$mem" = "1G" ] || [ "$mem" = "1Gi" ] || [ "$meml" = "1G" ] || [ "$meml" = "1Gi" ]; then echo "Success: memory limit is 1G"; exit 0; else echo "Error: memory=$mem limits.memory=$meml"; exit 1; fi
