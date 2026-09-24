#!/bin/bash

# Check if the namespace exists
kubectl get namespace helm-basics &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "✅ Namespace 'helm-basics' exists"
  exit 0
else
  echo "❌ Namespace 'helm-basics' not found"
  exit 1
fi 