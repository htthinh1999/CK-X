#!/bin/bash
# Validate that the service 'public-web' in namespace 'networking' has correct port configurations

NAMESPACE="networking"
SERVICE_NAME="public-web"
EXPECTED_PORT=80
EXPECTED_TARGET_PORT=8080
EXPECTED_NODE_PORT=30080

# Check if the service exists
kubectl get service $SERVICE_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check service port configuration
SERVICE_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)

if [ -z "$SERVICE_PORT" ]; then
  echo "❌ Cannot determine service port for '$SERVICE_NAME'"
  exit 1
fi

if [ "$SERVICE_PORT" != "$EXPECTED_PORT" ]; then
  echo "❌ Service '$SERVICE_NAME' exposes port $SERVICE_PORT, not port $EXPECTED_PORT as required"
  exit 1
fi

echo "✅ Service '$SERVICE_NAME' correctly exposes port $SERVICE_PORT"

# Check target port configuration
TARGET_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)

if [ -z "$TARGET_PORT" ]; then
  echo "❌ Target port is not specified"
  exit 1
fi

if [ "$TARGET_PORT" != "$EXPECTED_TARGET_PORT" ]; then
  echo "❌ Service has incorrect target port: $TARGET_PORT, expected: $EXPECTED_TARGET_PORT"
  exit 1
fi

echo "✅ Service has correct target port: $TARGET_PORT"

# Check node port configuration
NODE_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)

if [ -z "$NODE_PORT" ]; then
  echo "❌ NodePort is not specified"
  exit 1
fi

if [ "$NODE_PORT" != "$EXPECTED_NODE_PORT" ]; then
  echo "❌ Service has incorrect node port: $NODE_PORT, expected: $EXPECTED_NODE_PORT"
  exit 1
fi

echo "✅ Service has correct node port: $NODE_PORT"

# Check if the target port exists in the pods
SERVICE_SELECTOR=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o json | jq -r '.spec.selector' 2>/dev/null)

if [ -n "$SERVICE_SELECTOR" ] && [ "$SERVICE_SELECTOR" != "null" ]; then
  # Format selector for kubectl label selector
  SELECTOR_STRING=""
  for key in $(echo $SERVICE_SELECTOR | jq -r 'keys[]'); do
    value=$(echo $SERVICE_SELECTOR | jq -r --arg key "$key" '.[$key]')
    if [ -n "$SELECTOR_STRING" ]; then
      SELECTOR_STRING="$SELECTOR_STRING,"
    fi
    SELECTOR_STRING="${SELECTOR_STRING}${key}=${value}"
  done

  # Get a pod that matches the selector
  POD_NAME=$(kubectl get pods -n $NAMESPACE -l "$SELECTOR_STRING" -o name 2>/dev/null | head -n 1 | cut -d '/' -f 2)

  if [ -n "$POD_NAME" ]; then
    # Check if the target port matches any container port in the pod
    CONTAINER_PORTS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[*].ports[*].containerPort}' 2>/dev/null)
    
    if [[ $CONTAINER_PORTS == *"$TARGET_PORT"* ]]; then
      echo "✅ Target port $TARGET_PORT matches container port in selected pods"
    else
      echo "⚠️  Target port $TARGET_PORT does not match any container port in pod $POD_NAME (ports: $CONTAINER_PORTS)"
    fi
  else
    echo "⚠️  No pods found matching service selector, cannot verify container ports"
  fi
fi

echo "✅ Service '$SERVICE_NAME' has correct port configuration (port: $SERVICE_PORT, targetPort: $TARGET_PORT, nodePort: $NODE_PORT)"
exit 0 