#!/bin/bash
# Validate that 'internal-app' ClusterIP service routes port 80 -> targetPort 8080 using TCP

SERVICE_NAME="internal-app"
NAMESPACE="networking"
EXPECTED_PORT=80
EXPECTED_TARGET_PORT=8080
EXPECTED_PROTOCOL="TCP"

# Check if the service exists
if ! kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Get actual values
ACTUAL_PORT=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ports[0].port}")
ACTUAL_TARGET_PORT=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ports[0].targetPort}")
ACTUAL_PROTOCOL=$(kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.ports[0].protocol}")

# Validate port
if [ "$ACTUAL_PORT" != "$EXPECTED_PORT" ]; then
  echo "❌ Service port is $ACTUAL_PORT, expected $EXPECTED_PORT"
  exit 1
fi

# Validate targetPort
if [ "$ACTUAL_TARGET_PORT" != "$EXPECTED_TARGET_PORT" ]; then
  echo "❌ Service targetPort is $ACTUAL_TARGET_PORT, expected $EXPECTED_TARGET_PORT"
  exit 1
fi

# Validate protocol
if [ "$ACTUAL_PROTOCOL" != "$EXPECTED_PROTOCOL" ]; then
  echo "❌ Service protocol is $ACTUAL_PROTOCOL, expected $EXPECTED_PROTOCOL"
  exit 1
fi

# Success
echo "✅ Service '$SERVICE_NAME' correctly maps port $EXPECTED_PORT to targetPort $EXPECTED_TARGET_PORT using $EXPECTED_PROTOCOL"
exit 0
