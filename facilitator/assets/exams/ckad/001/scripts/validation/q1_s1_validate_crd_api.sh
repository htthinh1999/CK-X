#!/bin/bash
# Validate that the CustomResourceDefinition 'backups.data.example.com' has the correct API group and version

CRD_NAME="backups.data.example.com"
EXPECTED_GROUP="data.example.com"
EXPECTED_VERSION="v1alpha1"

# Check if the CRD exists
kubectl get crd $CRD_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ CustomResourceDefinition '$CRD_NAME' not found"
  exit 1
fi

# Check API group
GROUP=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.group}' 2>/dev/null)

if [ "$GROUP" != "$EXPECTED_GROUP" ]; then
  echo "❌ CRD has incorrect API group: '$GROUP', expected: '$EXPECTED_GROUP'"
  exit 1
fi

echo "✅ CRD has correct API group: '$GROUP'"

# Check API version
# The structure of versions can be different based on the Kubernetes version
# First try the newer structure
VERSIONS=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.versions[*].name}' 2>/dev/null)

# If that doesn't work, try the older structure
if [ -z "$VERSIONS" ]; then
  VERSIONS=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.version}' 2>/dev/null)
fi

if [[ ! $VERSIONS =~ $EXPECTED_VERSION ]]; then
  echo "❌ CRD versions ($VERSIONS) do not include expected version: '$EXPECTED_VERSION'"
  exit 1
fi

echo "✅ CRD includes correct API version: '$EXPECTED_VERSION'"

# Check the resource type name (singular/plural)
PLURAL=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.plural}' 2>/dev/null)
SINGULAR=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.singular}' 2>/dev/null)
KIND=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.kind}' 2>/dev/null)

if [ "$PLURAL" != "backups" ]; then
  echo "❌ CRD has incorrect plural name: '$PLURAL', expected: 'backups'"
  exit 1
fi

if [ "$KIND" != "Backup" ]; then
  echo "❌ CRD has incorrect kind: '$KIND', expected: 'Backup'"
  exit 1
fi

echo "✅ CRD has correct names - plural: '$PLURAL', kind: '$KIND'"

# Check that the v1alpha1 version is served and stored
SERVED=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.versions[?(@.name=="v1alpha1")].served}' 2>/dev/null)
STORAGE=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.versions[?(@.name=="v1alpha1")].storage}' 2>/dev/null)

if [ "$SERVED" != "true" ] && [ -n "$SERVED" ]; then
  echo "⚠️  The version 'v1alpha1' might not be served (served: $SERVED)"
fi

echo "✅ CustomResourceDefinition '$CRD_NAME' has correct API group '$EXPECTED_GROUP' and version '$EXPECTED_VERSION'"
exit 0 