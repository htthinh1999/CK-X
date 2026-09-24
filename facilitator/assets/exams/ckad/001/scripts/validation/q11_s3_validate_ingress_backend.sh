#!/bin/bash
# Validate that the Ingress 'api-ingress' in namespace 'networking' routes traffic to service 'api-service' on port 80

NAMESPACE="networking"
INGRESS_NAME="api-ingress"
EXPECTED_HOST="api.example.com"
EXPECTED_SERVICE="api-service"
EXPECTED_PORT=80

# Check if the ingress exists
if ! kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "❌ Ingress '$INGRESS_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check if the service exists
if ! kubectl get service "$EXPECTED_SERVICE" -n "$NAMESPACE" > /dev/null 2>&1; then
  echo "⚠️  Service '$EXPECTED_SERVICE' not found in namespace '$NAMESPACE'"
fi

# Extract hosts
HOSTS=$(kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.rules[*].host}")
for HOST in $HOSTS; do
  if [ "$HOST" = "$EXPECTED_HOST" ]; then
    # For this host, get service names and ports
    SERVICES=$(kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.rules[?(@.host=='$HOST')].http.paths[*].backend.service.name}")
    PORTS=$(kubectl get ingress "$INGRESS_NAME" -n "$NAMESPACE" -o jsonpath="{.spec.rules[?(@.host=='$HOST')].http.paths[*].backend.service.port.number}")

    INDEX=0
    for SERVICE in $SERVICES; do
      PORT=$(echo $PORTS | awk -v idx=$((INDEX+1)) '{print $idx}')
      echo "🔍 Host '$HOST' routes to service: $SERVICE, port: $PORT"
      if [ "$SERVICE" = "$EXPECTED_SERVICE" ]; then
        if [ "$PORT" = "$EXPECTED_PORT" ] || [ "$PORT" = "http" ]; then
          echo "✅ Found correct backend service and port for host '$HOST'"
          exit 0
        else
          echo "⚠️  Service name matches but port is different: expected $EXPECTED_PORT, got $PORT"
        fi
      fi
      INDEX=$((INDEX+1))
    done
  fi
done

# If we get here, it means validation failed
echo "❌ Ingress does not route traffic to '$EXPECTED_SERVICE' on port $EXPECTED_PORT for host '$EXPECTED_HOST'"
exit 1
