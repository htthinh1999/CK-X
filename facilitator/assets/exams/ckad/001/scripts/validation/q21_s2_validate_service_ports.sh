#!/bin/bash
# Validate that the service ports match container ports for 'web-service' in namespace 'troubleshooting'

NAMESPACE="troubleshooting"
SERVICE_NAME="web-service"

# Get service selector and port
SERVICE_SELECTOR=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.selector}' 2>/dev/null)
SERVICE_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
TARGET_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)

if [ -z "$SERVICE_SELECTOR" ] || [ -z "$SERVICE_PORT" ] || [ -z "$TARGET_PORT" ]; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE' or port configuration is incomplete"
  exit 1
fi

# Format selector for kubectl label selector
SELECTOR_STRING=""
for key in $(echo $SERVICE_SELECTOR | jq -r 'keys[]'); do
  value=$(echo $SERVICE_SELECTOR | jq -r --arg key "$key" '.[$key]')
  if [ -n "$SELECTOR_STRING" ]; then
    SELECTOR_STRING="$SELECTOR_STRING,"
  fi
  SELECTOR_STRING="${SELECTOR_STRING}${key}=${value}"
done

# Get the container port from the pods matching the service selector
PODS=$(kubectl get pods -n $NAMESPACE -l "$SELECTOR_STRING" -o name 2>/dev/null)

if [ -z "$PODS" ]; then
  echo "❌ No pods found matching the service selector"
  exit 1
fi

CONTAINER_PORT_FOUND=false

for POD in $PODS; do
  POD_NAME=$(echo "$POD" | cut -d '/' -f 2)
  CONTAINER_PORTS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[*].ports[*].containerPort}' 2>/dev/null)
  
  if [[ $CONTAINER_PORTS == *"$TARGET_PORT"* ]]; then
    CONTAINER_PORT_FOUND=true
    break
  fi
done

if [ "$CONTAINER_PORT_FOUND" = false ]; then
  echo "❌ No container found with port $TARGET_PORT matching service target port"
  exit 1
fi

echo "✅ Service '$SERVICE_NAME' ports correctly match container ports (service port: $SERVICE_PORT, target port: $TARGET_PORT)"
exit 0 