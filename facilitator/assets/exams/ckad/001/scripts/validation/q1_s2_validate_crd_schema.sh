#!/bin/bash
# Validate that the CustomResourceDefinition 'backups.data.example.com' has required schema fields

CRD_NAME="backups.data.example.com"
REQUIRED_FIELDS=("spec.source" "spec.destination")

# Check if the CRD exists
kubectl get crd $CRD_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ CustomResourceDefinition '$CRD_NAME' not found"
  exit 1
fi

# Get the full CRD definition for inspection
CRD_JSON=$(kubectl get crd $CRD_NAME -o json)

# Check for schema validation in different Kubernetes API versions
# First, try to get the schema for v1 API
SCHEMA=$(echo "$CRD_JSON" | jq -r '.spec.versions[] | select(.name=="v1alpha1") | .schema.openAPIV3Schema // empty' 2>/dev/null)

# If that's empty, try the beta API versions
if [ -z "$SCHEMA" ]; then
  SCHEMA=$(echo "$CRD_JSON" | jq -r '.spec.validation.openAPIV3Schema // empty' 2>/dev/null)
fi

if [ -z "$SCHEMA" ]; then
  echo "❌ No schema validation found in the CRD"
  exit 1
fi

echo "✅ Schema validation is defined for the CRD"

# Check for the required properties in the schema
SCHEMA_PROPERTIES=$(echo "$CRD_JSON" | jq -r '.spec.versions[] | select(.name=="v1alpha1") | .schema.openAPIV3Schema.properties.spec.properties // empty' 2>/dev/null)

# If that's empty, try the beta API versions
if [ -z "$SCHEMA_PROPERTIES" ]; then
  SCHEMA_PROPERTIES=$(echo "$CRD_JSON" | jq -r '.spec.validation.openAPIV3Schema.properties.spec.properties // empty' 2>/dev/null)
fi

if [ -z "$SCHEMA_PROPERTIES" ]; then
  echo "❌ Could not find 'spec' properties in the schema"
  exit 1
fi

# Check for each required field
for field in "${REQUIRED_FIELDS[@]}"; do
  field_name=$(echo $field | cut -d'.' -f2)
  
  # Check if the field is defined in properties
  FIELD_DEF=$(echo "$SCHEMA_PROPERTIES" | jq -r ".$field_name // empty" 2>/dev/null)
  
  if [ -z "$FIELD_DEF" ]; then
    echo "❌ Required field '$field' is not defined in the schema"
    exit 1
  fi
  
  echo "✅ Field '$field' is defined in the schema"
  
  # Check if the field is a string type
  FIELD_TYPE=$(echo "$SCHEMA_PROPERTIES" | jq -r ".$field_name.type" 2>/dev/null)
  
  if [ "$FIELD_TYPE" != "string" ]; then
    echo "⚠️  Field '$field' is of type '$FIELD_TYPE', not 'string' as expected"
  fi
done

# Check if both fields are required
REQUIRED_LIST=$(echo "$CRD_JSON" | jq -r '.spec.versions[] | select(.name=="v1alpha1") | .schema.openAPIV3Schema.properties.spec.required // empty' 2>/dev/null)

# If that's empty, try the beta API versions
if [ -z "$REQUIRED_LIST" ]; then
  REQUIRED_LIST=$(echo "$CRD_JSON" | jq -r '.spec.validation.openAPIV3Schema.properties.spec.required // empty' 2>/dev/null)
fi

if [ -z "$REQUIRED_LIST" ]; then
  echo "⚠️  No required fields specified in the schema"
else
  # Check if both source and destination are in the required list
  if echo "$REQUIRED_LIST" | jq -e 'index("source")' > /dev/null && echo "$REQUIRED_LIST" | jq -e 'index("destination")' > /dev/null; then
    echo "✅ Both 'source' and 'destination' are marked as required fields"
  else
    echo "⚠️  Not all required fields ('source', 'destination') are marked as required in the schema"
  fi
fi

echo "✅ CRD schema includes the required fields 'spec.source' and 'spec.destination'"
exit 0 