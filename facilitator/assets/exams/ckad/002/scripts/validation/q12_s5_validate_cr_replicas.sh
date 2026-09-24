#!/bin/bash

# Check if the custom resource exists first
kubectl get application my-app -n crd-demo &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ Custom resource 'my-app' not found in namespace 'crd-demo'"
  exit 1
fi

# Check if the replicas field is set correctly
REPLICAS=$(kubectl get application my-app -n crd-demo -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [[ "$REPLICAS" != "3" ]]; then
  echo "❌ Custom resource should have spec.replicas=3. Current value: '$REPLICAS'"
  exit 1
fi

echo "✅ Custom resource has correct replicas field"
exit 0 