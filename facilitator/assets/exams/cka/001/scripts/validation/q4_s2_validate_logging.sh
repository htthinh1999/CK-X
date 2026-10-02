#!/bin/bash
# Validate logging functionality

NAMESPACE="monitoring"
POD_NAME="logger"

# Check if log file exists and is being written to
kubectl exec -n $NAMESPACE $POD_NAME -c busybox -- ls -l /var/log/app.log &> /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Log file /var/log/app.log does not exist"
    exit 1
fi

# Check if log file has recent entries
LOG_ENTRIES=$(kubectl exec -n $NAMESPACE $POD_NAME -c busybox -- wc -l /var/log/app.log | awk '{print $1}')
if [ "$LOG_ENTRIES" -lt 1 ]; then
    echo "❌ Log file has no entries"
    exit 1
fi

# Check if fluentd container is running (regular container or native sidecar)
FLUENTD_STATUS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o json | jq -c '[(.status.containerStatuses // [])[], (.status.initContainerStatuses // [])[]] | .[] | select(.name == "fluentd") | .state.running // empty')
if [ -z "$FLUENTD_STATUS" ]; then
    echo "❌ Fluentd container is not running"
    exit 1
fi

# Check if fluentd has correct configuration
FLUENTD_CONFIG=$(kubectl exec -n $NAMESPACE $POD_NAME -c fluentd -- cat /fluentd/etc/fluent.conf)
if [[ ! "$FLUENTD_CONFIG" =~ "source" ]] || [[ ! "$FLUENTD_CONFIG" =~ "match" ]]; then
    echo "❌ Fluentd configuration is incomplete"
    exit 1
fi

# Check if log volume is properly mounted
VOLUME_MOUNT=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.volumes[?(@.name=="log-volume")].emptyDir}')
if [ -z "$VOLUME_MOUNT" ]; then
    echo "❌ Log volume is not properly configured"
    exit 1
fi

echo "✅ Logging configuration is correct and functional"
exit 0 