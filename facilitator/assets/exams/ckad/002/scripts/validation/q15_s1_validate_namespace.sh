#!/bin/bash

# Check if the namespace exists
kubectl get namespace custom-columns-demo &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "✅ Namespace 'custom-columns-demo' exists"
  exit 0
else
  echo "❌ Namespace 'custom-columns-demo' not found"
  exit 1
fi 