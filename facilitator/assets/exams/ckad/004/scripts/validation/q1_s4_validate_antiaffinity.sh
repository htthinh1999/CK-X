#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod titan-alpha -n zeus -o jsonpath='{.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution}' 2>/dev/null)
if [ -n "$v" ]; then echo "Success: pod anti-affinity configured"; exit 0; else echo "Error: pod anti-affinity missing"; exit 1; fi
