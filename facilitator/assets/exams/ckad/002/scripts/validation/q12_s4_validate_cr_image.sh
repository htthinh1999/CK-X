#!/bin/bash

# Check if the custom resource exists first
kubectl get application my-app -n crd-demo &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ Custom resource 'my-app' not found in namespace 'crd-demo'"
  exit 1
fi

# Check if the image field is set correctly
IMAGE=$(kubectl get application my-app -n crd-demo -o jsonpath='{.spec.image}' 2>/dev/null)
if [[ "$IMAGE" != "nginx:1.19.0" ]]; then
  echo "❌ Custom resource should have spec.image='nginx:1.19.0'. Current value: '$IMAGE'"
  exit 1
fi

echo "✅ Custom resource has correct image field"
exit 0 