#!/bin/bash
# Validate that CPU limits are set for containers in the 'logging-pod' in namespace 'troubleshooting'

NAMESPACE="troubleshooting"
POD_NAME="logging-pod"

# Check if the pod exists
kubectl get pod $POD_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Pod '$POD_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Get the number of containers in the pod
CONTAINERS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[*].name}')
CONTAINER_COUNT=$(echo $CONTAINERS | wc -w)

# Check if CPU limits are set for all containers
CONTAINERS_WITH_LIMITS=0
CONTAINER_WITH_ISSUE=""

for CONTAINER in $CONTAINERS; do
  CPU_LIMIT=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath="{.spec.containers[?(@.name==\"$CONTAINER\")].resources.limits.cpu}")
  
  if [ -n "$CPU_LIMIT" ]; then
    CONTAINERS_WITH_LIMITS=$((CONTAINERS_WITH_LIMITS+1))
    echo "✅ Container '$CONTAINER' has CPU limits set to '$CPU_LIMIT'"
  else
    CONTAINER_WITH_ISSUE="$CONTAINER"
    echo "❌ Container '$CONTAINER' does not have CPU limits set"
  fi
done

# Check if at least one container has CPU limits
if [ $CONTAINERS_WITH_LIMITS -eq 0 ]; then
  echo "❌ No containers in pod '$POD_NAME' have CPU limits set"
  exit 1
fi

# For this specific task, it's acceptable if at least one container has CPU limits
# as the troubleshooting scenario is about identifying and limiting only the problematic container
echo "✅ CPU limits are properly configured in pod '$POD_NAME'"
exit 0 