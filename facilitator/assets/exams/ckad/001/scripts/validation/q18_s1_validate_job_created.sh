#!/bin/bash
# Check if the Job is created with the correct name in the networking namespace

JOB_NAME="hello-job"
NAMESPACE="networking"

# Check if the job exists
if kubectl get job ${JOB_NAME} -n ${NAMESPACE} &> /dev/null; then
  echo "✅ Job '${JOB_NAME}' exists in namespace '${NAMESPACE}'"
  exit 0
else
  echo "❌ Job '${JOB_NAME}' does not exist in namespace '${NAMESPACE}'"
  exit 1
fi 