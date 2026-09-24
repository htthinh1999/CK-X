#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/3/kustomization.yaml
if [ -f "$F" ] && grep -q "patch.json" "$F"; then
  echo "Success: patch.json referenced in kustomization.yaml"
  exit 0
else
  echo "Error: patch.json not referenced in kustomization.yaml"
  exit 1
fi
