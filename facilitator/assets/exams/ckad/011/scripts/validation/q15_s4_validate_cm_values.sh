#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
host=$(kubectl get configmap env-config -n voyage -o jsonpath='{.data.DB_HOST}' 2>/dev/null)
port=$(kubectl get configmap env-config -n voyage -o jsonpath='{.data.DB_PORT}' 2>/dev/null)
if [ "$host" = "localhost" ] && [ "$port" = "5432" ]; then
  echo "Success: ConfigMap has DB_HOST=localhost, DB_PORT=5432"
  exit 0
else
  echo "Error: ConfigMap values incorrect (DB_HOST='$host', DB_PORT='$port')"
  exit 1
fi
