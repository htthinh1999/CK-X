#!/bin/bash
# Validate that the Kubernetes Job 'backup-job' in namespace 'networking' is created and completed successfully

NAMESPACE="networking"
JOB_NAME="backup-job"

# Check if the job exists
kubectl get job $JOB_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Job '$JOB_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi

# Check job completion status
COMPLETIONS=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.status.succeeded}' 2>/dev/null)

if [ -z "$COMPLETIONS" ]; then
  echo "❌ Job '$JOB_NAME' status could not be determined"
  exit 1
fi

if [ "$COMPLETIONS" -eq 0 ]; then
  # If job hasn't completed, check if it's still active
  ACTIVE=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.status.active}' 2>/dev/null)
  
  if [ -n "$ACTIVE" ] && [ "$ACTIVE" -gt 0 ]; then
    echo "⚠️  Job '$JOB_NAME' is still running (active: $ACTIVE)"
  else
    # Check if it failed
    FAILED=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.status.failed}' 2>/dev/null)
    
    if [ -n "$FAILED" ] && [ "$FAILED" -gt 0 ]; then
      echo "❌ Job '$JOB_NAME' has failed (failed: $FAILED)"
      
      # Get pod logs for troubleshooting
      POD_NAME=$(kubectl get pods -n $NAMESPACE -l job-name=$JOB_NAME -o name | head -n 1)
      if [ -n "$POD_NAME" ]; then
        echo "🔍 Last logs from the job pod ($POD_NAME):"
        kubectl logs $POD_NAME -n $NAMESPACE --tail=20
      fi
      
      exit 1
    else
      echo "⚠️  Job '$JOB_NAME' has not completed yet and is not active or failed, waiting for completion"
      exit 1
    fi
  fi
  
  exit 1
fi

echo "✅ Job '$JOB_NAME' has completed successfully (succeeded: $COMPLETIONS)"

# Check the pods created by the job
PODS=$(kubectl get pods -n $NAMESPACE -l job-name=$JOB_NAME -o name)

if [ -z "$PODS" ]; then
  echo "⚠️  No pods found for job '$JOB_NAME'"
else
  echo "ℹ️  Pods created by the job: $PODS"
  
  # Check if the copy command was executed by examining logs
  POD_NAME=$(echo $PODS | cut -d ' ' -f 1 | cut -d '/' -f 2)
  
  if [ -n "$POD_NAME" ]; then
    LOGS=$(kubectl logs $POD_NAME -n $NAMESPACE 2>/dev/null)
    
    if [ -n "$LOGS" ]; then
      echo "ℹ️  Job logs show command execution:"
      echo "$LOGS" | head -n 5
    fi
  fi
fi

exit 0 