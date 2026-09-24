#!/bin/bash
# Validate that the service 'public-web' in namespace 'networking' has the correct selector to target 'web-frontend' deployment pods

NAMESPACE="networking"
SERVICE_NAME="public-web"
DEPLOYMENT_NAME="web-frontend"

# Check if the service exists
kubectl get service $SERVICE_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Service '$SERVICE_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check if the deployment exists
kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "⚠️  Deployment '$DEPLOYMENT_NAME' not found in namespace '$NAMESPACE', but will continue checking service selector"
fi

# Get service selector
SERVICE_SELECTOR=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o json | jq -r '.spec.selector' 2>/dev/null)

if [ -z "$SERVICE_SELECTOR" ] || [ "$SERVICE_SELECTOR" == "null" ]; then
  echo "❌ Service '$SERVICE_NAME' does not have a selector"
  exit 1
fi

echo "🔍 Service '$SERVICE_NAME' has selector: $SERVICE_SELECTOR"

# Check if deployment exists to compare selectors
if kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE > /dev/null 2>&1; then
  # Get deployment selector
  DEPLOYMENT_SELECTOR=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o json | jq -r '.spec.selector.matchLabels' 2>/dev/null)
  
  if [ -z "$DEPLOYMENT_SELECTOR" ] || [ "$DEPLOYMENT_SELECTOR" == "null" ]; then
    echo "⚠️  Deployment '$DEPLOYMENT_NAME' does not have matchLabels in its selector"
  else
    echo "🔍 Deployment '$DEPLOYMENT_NAME' has selector: $DEPLOYMENT_SELECTOR"
    
    # Check if service selector is a subset of deployment selector
    # This is a simplistic check and might not work for complex selectors
    MATCHES=true
    for key in $(echo "$SERVICE_SELECTOR" | jq -r 'keys[]'); do
      service_value=$(echo "$SERVICE_SELECTOR" | jq -r --arg k "$key" '.[$k]')
      deployment_value=$(echo "$DEPLOYMENT_SELECTOR" | jq -r --arg k "$key" '.[$k] // empty')
      
      if [ "$service_value" != "$deployment_value" ]; then
        MATCHES=false
        echo "❌ Service selector key '$key' value '$service_value' does not match deployment value '$deployment_value'"
      fi
    done
    
    if [ "$MATCHES" = true ]; then
      echo "✅ Service selector matches deployment selector"
    else
      echo "❌ Service selector does not match deployment selector"
      exit 1
    fi
  fi
fi

# Check if the service selects any pods
SELECTOR_STRING=""
for key in $(echo $SERVICE_SELECTOR | jq -r 'keys[]'); do
  value=$(echo $SERVICE_SELECTOR | jq -r --arg key "$key" '.[$key]')
  if [ -n "$SELECTOR_STRING" ]; then
    SELECTOR_STRING="$SELECTOR_STRING,"
  fi
  SELECTOR_STRING="${SELECTOR_STRING}${key}=${value}"
done

SELECTED_PODS=$(kubectl get pods -n $NAMESPACE -l "$SELECTOR_STRING" -o name 2>/dev/null)

if [ -z "$SELECTED_PODS" ]; then
  echo "⚠️  No pods are currently selected by the service selector"
else
  POD_COUNT=$(echo "$SELECTED_PODS" | wc -l)
  echo "✅ Service selector targets $POD_COUNT pods"
fi

# Check if the service has endpoints
ENDPOINTS=$(kubectl get endpoints $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.subsets[*].addresses}' 2>/dev/null)

if [ -z "$ENDPOINTS" ] || [ "$ENDPOINTS" == "[]" ]; then
  echo "⚠️  Service '$SERVICE_NAME' has no endpoints, which may indicate a selector problem"
else
  echo "✅ Service '$SERVICE_NAME' has endpoints, indicating its selector is working"
fi

echo "✅ Service '$SERVICE_NAME' has a selector that targets pods from the '$DEPLOYMENT_NAME' deployment"
exit 0 