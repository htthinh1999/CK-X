#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mp=$(kubectl get pod web-setup -n fortress -o jsonpath='{.spec.containers[0].volumeMounts[?(@.name=="work-vol")].mountPath}' 2>/dev/null)
[ "$mp" = "/usr/share/nginx/html" ] && { echo "Success: work-vol mounted at /usr/share/nginx/html"; exit 0; }
echo "Error: work-vol mountPath is '$mp', expected /usr/share/nginx/html"; exit 1
