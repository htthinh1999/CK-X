#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/3/kustomization.yaml ] && [ -f /tmp/exam/course/3/patch.json ]; then
  echo "Success: kustomization.yaml and patch.json both exist"
  exit 0
else
  echo "Error: kustomization.yaml or patch.json missing"
  exit 1
fi
