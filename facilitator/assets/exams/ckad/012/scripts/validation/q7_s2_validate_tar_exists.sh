#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/7/oni-app.tar" ]; then echo "Success: tar archive exists"; exit 0
else echo "Error: tar archive not found at /tmp/exam/course/7/oni-app.tar"; exit 1; fi
