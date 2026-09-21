#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ready=$(kubectl get deployment rolling-app -n pounce -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
rep=$(kubectl get deployment rolling-app -n pounce -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ -n "$rep" ] && [ "$ready" = "$rep" ]; then echo "Success: rollout completed ($ready/$rep)"; exit 0; else echo "Error: rollout not complete ($ready/$rep)"; exit 1; fi
