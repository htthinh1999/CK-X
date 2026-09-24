#!/bin/bash
# Validate that NetworkPolicy 'allow-traffic' has correct ingress rules:
# from pods with label tier=frontend and allows TCP on port 80

NAMESPACE="networking"
POLICY_NAME="allow-traffic"
EXPECTED_FROM_KEY="tier"
EXPECTED_FROM_VALUE="frontend"
EXPECTED_PROTOCOL="TCP"
EXPECTED_PORT="80"

# Check if the NetworkPolicy exists
if ! kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "❌ NetworkPolicy '$POLICY_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Validate podSelector in ingress.from
ACTUAL_FROM_VALUE=$(kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ingress[0].from[0].podSelector.matchLabels.$EXPECTED_FROM_KEY}")
if [ "$ACTUAL_FROM_VALUE" != "$EXPECTED_FROM_VALUE" ]; then
  echo "❌ Ingress rule does not match expected podSelector: $EXPECTED_FROM_KEY=$EXPECTED_FROM_VALUE"
  echo "Found: $EXPECTED_FROM_KEY=$ACTUAL_FROM_VALUE"
  exit 1
fi

# Validate port and protocol
ACTUAL_PORT=$(kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ingress[0].ports[0].port}")
ACTUAL_PROTOCOL=$(kubectl get networkpolicy "$POLICY_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ingress[0].ports[0].protocol}")

if [ "$ACTUAL_PORT" != "$EXPECTED_PORT" ] || [ "$ACTUAL_PROTOCOL" != "$EXPECTED_PROTOCOL" ]; then
  echo "❌ Ingress rule does not allow expected port/protocol"
  echo "Expected: $EXPECTED_PROTOCOL $EXPECTED_PORT"
  echo "Found:    $ACTUAL_PROTOCOL $ACTUAL_PORT"
  exit 1
fi

# Success!
echo "✅ NetworkPolicy '$POLICY_NAME' has correct ingress rules: from pods with label '$EXPECTED_FROM_KEY=$EXPECTED_FROM_VALUE', allowing $EXPECTED_PROTOCOL on port $EXPECTED_PORT"
exit 0
