#!/bin/bash
# Validate that NetworkPolicy 'allow-traffic' has correct pod selector: app=web

NAMESPACE="networking"
POLICY_NAME="allow-traffic"
EXPECTED_KEY="app"
EXPECTED_VALUE="web"

# Check if the NetworkPolicy exists
if ! kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "❌ NetworkPolicy '$POLICY_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Fetch the podSelector key and value
ACTUAL_KEY=$(kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.podSelector.matchLabels}" | grep -o '"[^"]*":' | tr -d '"':)
ACTUAL_VALUE=$(kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.podSelector.matchLabels.$EXPECTED_KEY}")

# Validate key and value
if [ "$ACTUAL_KEY" != "$EXPECTED_KEY" ] || [ "$ACTUAL_VALUE" != "$EXPECTED_VALUE" ]; then
  echo "❌ NetworkPolicy '$POLICY_NAME' has incorrect podSelector"
  echo "Expected: $EXPECTED_KEY=$EXPECTED_VALUE"
  echo "Found: $ACTUAL_KEY=$ACTUAL_VALUE"
  exit 1
fi

# Success
echo "✅ NetworkPolicy '$POLICY_NAME' has correct podSelector: $EXPECTED_KEY=$EXPECTED_VALUE"
exit 0
