#!/bin/bash
# Check if the Job completes successfully

JOB_NAME="hello-job"
NAMESPACE="networking"

# Check if the job exists
if ! kubectl get job ${JOB_NAME} -n ${NAMESPACE} &> /dev/null; then
  echo "❌ Job '${JOB_NAME}' does not exist in namespace '${NAMESPACE}'"
  exit 1
fi

# Check if the job has completed
STATUS=$(kubectl get job ${JOB_NAME} -n ${NAMESPACE} -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')
if [[ "$STATUS" == "True" ]]; then
  echo "✅ Job '${JOB_NAME}' has completed successfully"
  
  # Check if the job's pod generated the expected output
  POD_NAME=$(kubectl get pods -n ${NAMESPACE} -l job-name=${JOB_NAME} -o jsonpath='{.items[0].metadata.name}')
  if [ -n "$POD_NAME" ]; then
    LOG=$(kubectl logs ${POD_NAME} -n ${NAMESPACE})
    if [[ "$LOG" == *"Hello from Kubernetes job!"* ]]; then
      echo "✅ Job pod produced expected output: '$LOG'"
      exit 0
    else
      echo "❌ Job pod did not produce expected output. Found: '$LOG'"
      exit 1
    fi
  else
    echo "⚠️ Could not find pod for job, but job shows as complete"
    exit 0
  fi
else
  # If not completed, check if it's still running (could be normal)
  ACTIVE=$(kubectl get job ${JOB_NAME} -n ${NAMESPACE} -o jsonpath='{.status.active}')
  if [[ "$ACTIVE" == "1" ]]; then
    echo "⚠️ Job '${JOB_NAME}' is still running. Please wait for it to complete."
    exit 1
  else
    # If not active and not complete, check for failure
    FAILED=$(kubectl get job ${JOB_NAME} -n ${NAMESPACE} -o jsonpath='{.status.failed}')
    if [[ -n "$FAILED" && "$FAILED" -gt 0 ]]; then
      echo "❌ Job '${JOB_NAME}' has failed with $FAILED failures"
      
      # Try to get logs from the failed pod for debugging
      FAILED_POD=$(kubectl get pods -n ${NAMESPACE} -l job-name=${JOB_NAME} -o jsonpath='{.items[0].metadata.name}')
      if [ -n "$FAILED_POD" ]; then
        echo "❌ Error logs: $(kubectl logs ${FAILED_POD} -n ${NAMESPACE})"
      fi
      exit 1
    else
      echo "❌ Job '${JOB_NAME}' has not completed and is not running"
      exit 1
    fi
  fi
fi 