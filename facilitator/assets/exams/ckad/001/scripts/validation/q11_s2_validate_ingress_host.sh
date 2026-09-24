#!/bin/bash
# Validate that the Ingress 'api-ingress' in namespace 'networking' has the correct host 'api.example.com'

NAMESPACE="networking"
INGRESS_NAME="api-ingress"
EXPECTED_HOST="api.example.com"

# Check if the ingress exists
kubectl get ingress $INGRESS_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Ingress '$INGRESS_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Try different structures for different Kubernetes API versions
# For networking.k8s.io/v1 API
HOSTS_V1=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[*].host}' 2>/dev/null)

if [ -z "$HOSTS_V1" ]; then
  # For extensions/v1beta1 or networking.k8s.io/v1beta1 API
  HOSTS_BETA=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[*].host}' 2>/dev/null)
  
  if [ -n "$HOSTS_BETA" ]; then
    HOSTS=$HOSTS_BETA
  else
    echo "❌ No hosts found in Ingress rules"
    exit 1
  fi
else
  HOSTS=$HOSTS_V1
fi

# Check if expected host is in the list of hosts
FOUND=false
for HOST in $HOSTS; do
  if [ "$HOST" == "$EXPECTED_HOST" ]; then
    FOUND=true
    break
  fi
done

if [ "$FOUND" = true ]; then
  echo "✅ Ingress '$INGRESS_NAME' has the correct host: '$EXPECTED_HOST'"
else
  echo "❌ Ingress '$INGRESS_NAME' does not have the expected host '$EXPECTED_HOST'. Found hosts: $HOSTS"
  exit 1
fi

# Check if there are TLS settings for the host
TLS_HOSTS=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.tls[*].hosts[*]}' 2>/dev/null)

if [ -n "$TLS_HOSTS" ]; then
  # Check if expected host is in TLS hosts
  TLS_FOUND=false
  for TLS_HOST in $TLS_HOSTS; do
    if [ "$TLS_HOST" == "$EXPECTED_HOST" ]; then
      TLS_FOUND=true
      break
    fi
  done
  
  if [ "$TLS_FOUND" = true ]; then
    echo "ℹ️  TLS is configured for host '$EXPECTED_HOST'"
  else
    echo "ℹ️  TLS is configured but not for host '$EXPECTED_HOST'"
  fi
fi

echo "✅ Ingress '$INGRESS_NAME' is correctly configured with host '$EXPECTED_HOST'"
exit 0 