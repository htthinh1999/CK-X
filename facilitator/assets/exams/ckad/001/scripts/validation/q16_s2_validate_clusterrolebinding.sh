#!/bin/bash
# Validate that the ClusterRoleBinding 'read-pods' correctly associates the 'pod-reader' ClusterRole with user 'jane'

CLUSTERROLEBINDING_NAME="read-pods"
CLUSTERROLE_NAME="pod-reader"
USER_NAME="jane"

# Check if the ClusterRoleBinding exists
if ! kubectl get clusterrolebinding "$CLUSTERROLEBINDING_NAME" > /dev/null 2>&1; then
  echo "❌ ClusterRoleBinding '$CLUSTERROLEBINDING_NAME' not found"
  exit 1
fi

# Check if the ClusterRoleBinding references the correct ClusterRole
ROLE_REF=$(kubectl get clusterrolebinding "$CLUSTERROLEBINDING_NAME" -o jsonpath='{.roleRef.name}')
if [ "$ROLE_REF" != "$CLUSTERROLE_NAME" ]; then
  echo "❌ ClusterRoleBinding '$CLUSTERROLEBINDING_NAME' references role '$ROLE_REF' instead of '$CLUSTERROLE_NAME'"
  exit 1
fi

# Check if the roleRef kind is 'ClusterRole'
ROLE_KIND=$(kubectl get clusterrolebinding "$CLUSTERROLEBINDING_NAME" -o jsonpath='{.roleRef.kind}')
if [ "$ROLE_KIND" != "ClusterRole" ]; then
  echo "❌ ClusterRoleBinding '$CLUSTERROLEBINDING_NAME' references a '$ROLE_KIND' instead of a 'ClusterRole'"
  exit 1
fi

# Check if the ClusterRoleBinding binds to user 'jane'
SUBJECTS=$(kubectl get clusterrolebinding "$CLUSTERROLEBINDING_NAME" -o json)

USER_BOUND=$(echo "$SUBJECTS" | grep -A 2 '"kind": "User"' | grep -q "\"name\": \"$USER_NAME\"" && echo "yes" || echo "no")

if [ "$USER_BOUND" != "yes" ]; then
  echo "❌ ClusterRoleBinding '$CLUSTERROLEBINDING_NAME' does not bind to user '$USER_NAME'"
  exit 1
fi

# Success
echo "✅ ClusterRoleBinding '$CLUSTERROLEBINDING_NAME' correctly associates ClusterRole '$CLUSTERROLE_NAME' with user '$USER_NAME'"
echo "✅ This binding grants '$USER_NAME' read-only access to pod resources across all namespaces"
exit 0
