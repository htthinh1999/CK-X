#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
w=$(kubectl get deployment spread-deploy -n blaze -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].whenUnsatisfiable}' 2>/dev/null)
if [ "$w" = "ScheduleAnyway" ]; then
  echo "Success: whenUnsatisfiable ScheduleAnyway"
  exit 0
else
  echo "Error: whenUnsatisfiable is '$w', expected ScheduleAnyway"
  exit 1
fi
