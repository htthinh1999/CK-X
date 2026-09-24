#!/bin/bash
# Validate that the Ingress 'api-ingress' is created in namespace 'networking'

NAMESPACE="networking"
INGRESS_NAME="api-ingress"

# Check if the ingress exists
kubectl get ingress $INGRESS_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Ingress '$INGRESS_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Get the API version of the Ingress
API_VERSION=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.apiVersion}' 2>/dev/null)

echo "ℹ️  Ingress '$INGRESS_NAME' exists in namespace '$NAMESPACE' (API version: $API_VERSION)"

# Check for any ingressClassName or annotations for ingress controller class
INGRESS_CLASS=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)
INGRESS_CLASS_ANNOTATION=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.metadata.annotations.kubernetes\.io/ingress\.class}' 2>/dev/null)

if [ -n "$INGRESS_CLASS" ]; then
  echo "ℹ️  Ingress is using ingressClassName: $INGRESS_CLASS"
elif [ -n "$INGRESS_CLASS_ANNOTATION" ]; then
  echo "ℹ️  Ingress is using annotation for ingress class: $INGRESS_CLASS_ANNOTATION"
fi

echo "✅ Ingress '$INGRESS_NAME' is successfully created in namespace '$NAMESPACE'"
exit 0 