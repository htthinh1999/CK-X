#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment battle-app -n ares -o jsonpath='{.spec.paused}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: rollout paused"; exit 0; else echo "Error: paused is '$v', expected true"; exit 1; fi
