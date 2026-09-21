#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get pod secret-env-pod -n coral >/dev/null 2>&1; then
  echo "Error: pod secret-env-pod not found in coral"; exit 1
fi
e1=$(kubectl get pod secret-env-pod -n coral -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_USER")].valueFrom.secretKeyRef.key}' 2>/dev/null)
e2=$(kubectl get pod secret-env-pod -n coral -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_PASS")].valueFrom.secretKeyRef.key}' 2>/dev/null)
if [ "$e1" = "username" ] && [ "$e2" = "password" ]; then
  echo "Success: DB_USER->username and DB_PASS->password configured"; exit 0
fi
echo "Error: env vars incorrect (DB_USER key='$e1', DB_PASS key='$e2')"; exit 1
