#!/bin/bash

# Check if the namespace exists
kubectl get namespace crd-demo &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "✅ Namespace 'crd-demo' exists"
  exit 0
else
  echo "❌ Namespace 'crd-demo' not found"
  exit 1
fi 