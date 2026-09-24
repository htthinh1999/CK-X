#!/bin/bash

# Check if the Pod exists
POD_EXISTS=$(kubectl get pod config-pod -n pod-configuration --no-headers --output=name 2>/dev/null | wc -l)
if [[ "$POD_EXISTS" -eq 0 ]]; then
  echo "❌ Pod 'config-pod' not found in namespace 'pod-configuration'"
  exit 1
fi

# Check if there's a volume that uses the ConfigMap
CM_VOLUME=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.volumes[?(@.configMap.name=="app-config")].name}' 2>/dev/null)
if [[ -z "$CM_VOLUME" ]]; then
  echo "❌ Pod 'config-pod' does not have a volume using ConfigMap 'app-config'"
  exit 1
fi

# Check if the volume is mounted at the correct location
VOLUME_MOUNT=$(kubectl get pod config-pod -n pod-configuration -o jsonpath="{.spec.containers[0].volumeMounts[?(@.name==\"$CM_VOLUME\")].mountPath}" 2>/dev/null)
if [[ "$VOLUME_MOUNT" != "/etc/app-config" ]]; then
  echo "❌ ConfigMap volume is not mounted at '/etc/app-config' in pod 'config-pod'"
  exit 1
fi

echo "✅ Pod 'config-pod' correctly mounts ConfigMap 'app-config' as a volume at '/etc/app-config'"
exit 0 