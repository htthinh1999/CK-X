#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
key=$(kubectl get pod db-consumer -n citadel -o jsonpath='{.spec.volumes[?(@.secret.secretName=="db-credentials")].secret.items[0].key}' 2>/dev/null)
path=$(kubectl get pod db-consumer -n citadel -o jsonpath='{.spec.volumes[?(@.secret.secretName=="db-credentials")].secret.items[0].path}' 2>/dev/null)
[ "$key" = "password" ] && [ "$path" = "db-pass.txt" ] && { echo "Success: password mounted as db-pass.txt"; exit 0; }
echo "Error: item key='$key' path='$path', expected password/db-pass.txt"; exit 1
