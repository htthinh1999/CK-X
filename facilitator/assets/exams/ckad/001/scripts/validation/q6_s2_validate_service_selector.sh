#!/bin/bash
# Validate that the 'internal-app' ClusterIP service has selector app=backend

SERVICE_NAME="internal-app"
NAMESPACE="networking"
EXPECTED_KEY="app"
EXPECTED_VALUE="backend"

# Check if the service exists
if ! kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Fetch selector key and value
ACTUAL_SELECTOR_VALUE=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.selector.$EXPECTED_KEY}")

if [ "$ACTUAL_SELECTOR_VALUE" != "$EXPECTED_VALUE" ]; then
  echo "❌ Service selector mismatch"
  echo "Expected: $EXPECTED_KEY=$EXPECTED_VALUE"
  echo "Found: $EXPECTED_KEY=$ACTUAL_SELECTOR_VALUE"
  exit 1
fi

# Success
echo "✅ Service '$SERVICE_NAME' in namespace '$NAMESPACE' has correct selector: $EXPECTED_KEY=$EXPECTED_VALUE"
exit 0
