#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

mp=$(kubectl get pod vol-pod -n cliff -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
mp="${mp%/}"
if [ "$mp" = "/etc/lala" ]; then echo "Success: mounted at /etc/lala"; exit 0; else echo "Error: mount path is '$mp'"; exit 1; fi
