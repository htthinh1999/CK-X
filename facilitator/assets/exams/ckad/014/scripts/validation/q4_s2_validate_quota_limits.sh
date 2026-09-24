#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
pods=$(kubectl get resourcequota compute-quota -n nightfall -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
cpu=$(kubectl get resourcequota compute-quota -n nightfall -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)
mem=$(kubectl get resourcequota compute-quota -n nightfall -o jsonpath='{.spec.hard.limits\.memory}' 2>/dev/null)
if [ "$pods" == "4" ] && [ "$cpu" == "2" ] && [ "$mem" == "4Gi" ]; then
  echo "Success: quota limits correct (pods=4, requests.cpu=2, limits.memory=4Gi)"
  exit 0
else
  echo "Error: quota limits incorrect (pods=$pods, cpu=$cpu, mem=$mem)"
  exit 1
fi
