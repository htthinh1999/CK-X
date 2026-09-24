#!/bin/bash
# Validate that the service 'public-web' in namespace 'networking' is of type NodePort with correct nodePort

NAMESPACE="networking"
SERVICE_NAME="public-web"
EXPECTED_TYPE="NodePort"
EXPECTED_NODE_PORT=30080

# Check if the service exists
kubectl get service $SERVICE_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check service type
SERVICE_TYPE=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.type}' 2>/dev/null)

if [ -z "$SERVICE_TYPE" ]; then
  echo "❌ Cannot determine service type for '$SERVICE_NAME'"
  exit 1
fi

if [ "$SERVICE_TYPE" != "$EXPECTED_TYPE" ]; then
  echo "❌ Service '$SERVICE_NAME' is of type '$SERVICE_TYPE', not '$EXPECTED_TYPE' as required"
  exit 1
fi

echo "✅ Service '$SERVICE_NAME' is correctly configured as type '$EXPECTED_TYPE'"

# Check nodePort value
NODE_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)

if [ -z "$NODE_PORT" ]; then
  echo "❌ NodePort is not configured for service '$SERVICE_NAME'"
  exit 1
fi

if [ "$NODE_PORT" -ne "$EXPECTED_NODE_PORT" ]; then
  echo "❌ Service '$SERVICE_NAME' uses nodePort $NODE_PORT, expected $EXPECTED_NODE_PORT"
  exit 1
fi

echo "✅ Service '$SERVICE_NAME' is correctly configured with nodePort: $NODE_PORT"
exit 0 