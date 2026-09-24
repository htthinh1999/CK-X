#!/bin/bash

# Check if the CRD exists first (prerequisite)
kubectl get crd applications.training.ckad.io &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ CRD 'applications.training.ckad.io' not found. Cannot validate custom resources."
  exit 1
fi

# Check if the custom resource exists
kubectl get application my-app -n crd-demo &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ Custom resource 'my-app' not found in namespace 'crd-demo'"
  exit 1
fi

echo "✅ Custom resource 'my-app' exists with correct name"
exit 0 