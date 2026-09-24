#!/bin/bash
# Validate that the service 'web-service' has selectors that match pod labels in namespace 'troubleshooting'

NAMESPACE="troubleshooting"
SERVICE_NAME="web-service"

# Get service selector
SERVICE_SELECTOR=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.selector}' 2>/dev/null)

if [ -z "$SERVICE_SELECTOR" ]; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE' or selector is not defined"
  exit 1
fi

# Get selector in key=value format for matching against pod labels
SELECTOR_STRING=""
for key in $(echo $SERVICE_SELECTOR | jq -r 'keys[]'); do
  value=$(echo $SERVICE_SELECTOR | jq -r --arg key "$key" '.[$key]')
  if [ -n "$SELECTOR_STRING" ]; then
    SELECTOR_STRING="$SELECTOR_STRING,"
  fi
  SELECTOR_STRING="${SELECTOR_STRING}${key}=${value}"
done

# Check if pods exist with matching labels
MATCHING_PODS=$(kubectl get pods -n $NAMESPACE -l "$SELECTOR_STRING" -o name 2>/dev/null)

if [ -z "$MATCHING_PODS" ]; then
  echo "❌ No pods found with labels matching service selector: $SELECTOR_STRING"
  exit 1
fi

# Count endpoints for service
ENDPOINTS=$(kubectl get endpoints $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.subsets[*].addresses}' 2>/dev/null)

if [ -z "$ENDPOINTS" ] || [ "$ENDPOINTS" == "[]" ]; then
  echo "❌ Service '$SERVICE_NAME' has no endpoints"
  exit 1
fi

echo "✅ Service '$SERVICE_NAME' selector '$SELECTOR_STRING' matches pod labels and has endpoints"
exit 0 