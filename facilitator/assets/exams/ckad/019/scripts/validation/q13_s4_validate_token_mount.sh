#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vm=$(kubectl get pod stealth-pod -n siege -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/run/secrets/custom-token")].name}' 2>/dev/null)
[ -n "$vm" ] && { echo "Success: token mounted at /var/run/secrets/custom-token"; exit 0; }
echo "Error: no volumeMount at /var/run/secrets/custom-token"; exit 1
