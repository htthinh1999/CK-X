#!/bin/bash
# Validate that the 'logging-pod' is running in namespace 'troubleshooting'


NAMESPACE="troubleshooting"
POD_NAME="logging-pod"

# Check if the pod exists
POD_STATUS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.status.phase}' 2>/dev/null)

if [ -z "$POD_STATUS" ]; then
  echo "❌ Pod '$POD_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

#validate `100m` and memory limits `50Mi` set for the container 

# Check if the pod is running
if [ "$POD_STATUS" != "Running" ]; then
  echo "❌ Pod '$POD_NAME' exists but is not running (current status: $POD_STATUS)" 
  exit 1
fi

# Check if the container has the correct CPU and memory limits
CONTAINER_NAME=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].name}')
CPU_LIMIT=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath="{.spec.containers[?(@.name==\"$CONTAINER_NAME\")].resources.limits.cpu}")  
MEMORY_LIMIT=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath="{.spec.containers[?(@.name==\"$CONTAINER_NAME\")].resources.limits.memory}")

if [ "$CPU_LIMIT" != "100m" ] || [ "$MEMORY_LIMIT" != "50Mi" ]; then
  echo "❌ Container '$CONTAINER_NAME' does not have the correct CPU and memory limits"
  exit 1
fi

echo "✅ Container '$CONTAINER_NAME' has the correct CPU and memory limits" 
exit 0 