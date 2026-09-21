#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

cur=$(kubectl get deployment nginx-deploy -n valley -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
rev1=$(kubectl rollout history deployment nginx-deploy -n valley --revision=1 2>/dev/null | awk '/Image:/ {print $2; exit}')
if [ "$cur" = "nginx:1.18.0" ] || [ "$rev1" = "nginx:1.18.0" ]; then echo "Success: image nginx:1.18.0 (current=$cur rev1=$rev1)"; exit 0; else echo "Error: nginx:1.18.0 not found (current=$cur rev1=$rev1)"; exit 1; fi
