#!/bin/bash
# Validate that the ClusterRole 'pod-reader' has the correct permissions for pod operations

CLUSTERROLE_NAME="pod-reader"

# Check if the ClusterRole exists
kubectl get clusterrole $CLUSTERROLE_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ ClusterRole '$CLUSTERROLE_NAME' not found"
  exit 1
fi

# Check if the ClusterRole has rules for pods
RESOURCE_PODS=$(kubectl get clusterrole $CLUSTERROLE_NAME -o jsonpath='{.rules[*].resources}' | grep -o "pods" | wc -l)

if [ $RESOURCE_PODS -eq 0 ]; then
  echo "❌ ClusterRole '$CLUSTERROLE_NAME' does not have rules for 'pods' resource"
  exit 1
fi

# Check for the required verbs: get, watch, and list
VERBS=$(kubectl get clusterrole $CLUSTERROLE_NAME -o jsonpath='{.rules[?(@.resources[*]=="pods")].verbs[*]}')

echo "🔍 Verifying required verbs in ClusterRole '$CLUSTERROLE_NAME'..."

# Check for 'get' verb
if [[ ! $VERBS =~ "get" ]]; then
  echo "❌ ClusterRole '$CLUSTERROLE_NAME' is missing 'get' verb for pods"
  exit 1
fi

# Check for 'watch' verb
if [[ ! $VERBS =~ "watch" ]]; then
  echo "❌ ClusterRole '$CLUSTERROLE_NAME' is missing 'watch' verb for pods"
  exit 1
fi

# Check for 'list' verb
if [[ ! $VERBS =~ "list" ]]; then
  echo "❌ ClusterRole '$CLUSTERROLE_NAME' is missing 'list' verb for pods"
  exit 1
fi

# Ensure that the ClusterRole doesn't provide excessive permissions
RESOURCE_COUNT=$(kubectl get clusterrole $CLUSTERROLE_NAME -o jsonpath='{.rules[*].resources}' | wc -w)
VERB_COUNT=$(kubectl get clusterrole $CLUSTERROLE_NAME -o jsonpath='{.rules[*].verbs}' | wc -w)

if [ $RESOURCE_COUNT -gt 1 ] || [ $VERB_COUNT -gt 3 ]; then
  echo "⚠️  ClusterRole '$CLUSTERROLE_NAME' may have more permissions than necessary for the least privilege principle"
fi

# Success
echo "✅ ClusterRole '$CLUSTERROLE_NAME' correctly allows get, watch, and list operations on pods"
exit 0 