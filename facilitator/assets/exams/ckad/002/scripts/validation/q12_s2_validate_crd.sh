#!/bin/bash

# Check if the CRD exists
kubectl get crd applications.training.ckad.io &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ CRD 'applications.training.ckad.io' not found"
  exit 1
fi

# Check group
GROUP=$(kubectl get crd applications.training.ckad.io -o jsonpath='{.spec.group}')
if [[ "$GROUP" != "training.ckad.io" ]]; then
  echo "❌ CRD has incorrect group. Expected 'training.ckad.io', got '$GROUP'"
  exit 1
fi

# Check kind
KIND=$(kubectl get crd applications.training.ckad.io -o jsonpath='{.spec.names.kind}')
if [[ "$KIND" != "Application" ]]; then
  echo "❌ CRD has incorrect kind. Expected 'Application', got '$KIND'"
  exit 1
fi

# Check scope
SCOPE=$(kubectl get crd applications.training.ckad.io -o jsonpath='{.spec.scope}')
if [[ "$SCOPE" != "Namespaced" ]]; then
  echo "❌ CRD has incorrect scope. Expected 'Namespaced', got '$SCOPE'"
  exit 1
fi

# Check for required fields in schema
# This is a simple check - in a real scenario we would do more validation
SCHEMA=$(kubectl get crd applications.training.ckad.io -o jsonpath='{.spec.versions[*].schema.openAPIV3Schema.properties.spec.properties}')
if [[ "$SCHEMA" != *"image"* || "$SCHEMA" != *"replicas"* ]]; then
  echo "❌ CRD schema should define 'image' and 'replicas' fields"
  exit 1
fi

echo "✅ CRD 'applications.training.ckad.io' is configured correctly"
exit 0 