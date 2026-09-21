#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
completions=$(kubectl get job data-processor -n pinnacle -o jsonpath='{.spec.completions}' 2>/dev/null)
parallelism=$(kubectl get job data-processor -n pinnacle -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$completions" = "3" ] && [ "$parallelism" = "2" ]; then
  echo "Success: completions=3 parallelism=2"
  exit 0
fi
echo "Error: completions='$completions' parallelism='$parallelism', expected 3 and 2"
exit 1
