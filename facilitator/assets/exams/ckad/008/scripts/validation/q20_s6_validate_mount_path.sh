#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

mp=$(kubectl get pod pv-pod -n alpine -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
mp="${mp%/}"
if [ "$mp" = "/etc/foo" ]; then echo "Success: mounted at /etc/foo"; exit 0; else echo "Error: mount path is '$mp'"; exit 1; fi
