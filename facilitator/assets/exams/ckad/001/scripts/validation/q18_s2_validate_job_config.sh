#!/bin/bash
# Validate that the Kubernetes Job 'backup-job' in namespace 'networking' has the correct configuration

NAMESPACE="networking"
JOB_NAME="hello-job"
EXPECTED_IMAGE="busybox"
EXPECTED_RESTART_POLICY="Never"
EXPECTED_BACKOFF_LIMIT=0

# Check if the job exists
kubectl get job $JOB_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Job '$JOB_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check for activeDeadlineSeconds set to 30
DEADLINE=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.activeDeadlineSeconds}')
if [[ "$DEADLINE" == "30" ]]; then
  echo "✅ Job has correct activeDeadlineSeconds value: 30"
else
  echo "❌ Job has incorrect activeDeadlineSeconds value: ${DEADLINE:-not set}"
  exit 1
fi

# Check the job's backoffLimit
BACKOFF_LIMIT=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)

if [ -z "$BACKOFF_LIMIT" ]; then
  echo "⚠️  Job '$JOB_NAME' does not have backoffLimit specified, using default (6)"
  BACKOFF_LIMIT=6
fi

if [ "$BACKOFF_LIMIT" -ne "$EXPECTED_BACKOFF_LIMIT" ]; then
  echo "❌ Job '$JOB_NAME' has incorrect backoffLimit: $BACKOFF_LIMIT, expected: $EXPECTED_BACKOFF_LIMIT"
  exit 1
fi

echo "✅ Job '$JOB_NAME' has correct backoffLimit: $BACKOFF_LIMIT"

# Check the pod template's restartPolicy
RESTART_POLICY=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null)

if [ -z "$RESTART_POLICY" ]; then
  echo "⚠️  Job '$JOB_NAME' does not have restartPolicy specified, using default (Always)"
  RESTART_POLICY="Always"
fi

if [ "$RESTART_POLICY" != "$EXPECTED_RESTART_POLICY" ]; then
  echo "❌ Job '$JOB_NAME' has incorrect restartPolicy: $RESTART_POLICY, expected: $EXPECTED_RESTART_POLICY"
  exit 1
fi

echo "✅ Job '$JOB_NAME' has correct restartPolicy: $RESTART_POLICY"

# Check the container image
IMAGE=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)

if [ -z "$IMAGE" ]; then
  echo "❌ Cannot determine container image for Job '$JOB_NAME'"
  exit 1
fi

# Check if the image contains the expected value (allowing for tags)
if [[ ! "$IMAGE" == *"$EXPECTED_IMAGE"* ]]; then
  echo "❌ Job '$JOB_NAME' uses incorrect image: $IMAGE, expected to contain: $EXPECTED_IMAGE"
  exit 1
fi

echo "✅ Job '$JOB_NAME' uses correct image: $IMAGE"

# Check if the job pod has a command to copy files
COMMAND=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].command}' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  # Try args if command is not set
  ARGS=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].args}' 2>/dev/null)
  
  if [ -z "$ARGS" ]; then
    echo "⚠️  Job '$JOB_NAME' does not specify a command or args"
  else
    echo "ℹ️  Job container args: $ARGS"
    
    # Check if the command contains references to copying files
    if [[ "$ARGS" == *"/etc/config"* ]] && [[ "$ARGS" == *"/backup"* ]] && [[ "$ARGS" == *"cp"* || "$ARGS" == *"copy"* || "$ARGS" == *"mv"* ]]; then
      echo "✅ Job contains a command that appears to copy files from /etc/config to /backup"
    else
      echo "⚠️  Job args do not appear to include copying files from /etc/config to /backup"
    fi
  fi
else
  echo "ℹ️  Job container command: $COMMAND"
  
  # Check if the command contains references to copying files
  if [[ "$COMMAND" == *"/etc/config"* ]] && [[ "$COMMAND" == *"/backup"* ]] && [[ "$COMMAND" == *"cp"* || "$COMMAND" == *"copy"* || "$COMMAND" == *"mv"* ]]; then
    echo "✅ Job contains a command that appears to copy files from /etc/config to /backup"
  else
    echo "⚠️  Job command does not appear to include copying files from /etc/config to /backup"
  fi
fi

echo "✅ Job '$JOB_NAME' has the correct configuration (restartPolicy: $RESTART_POLICY, backoffLimit: $BACKOFF_LIMIT, image: $IMAGE)"
exit 0 