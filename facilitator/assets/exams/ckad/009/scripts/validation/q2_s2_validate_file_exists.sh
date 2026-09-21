#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if [ -s /tmp/exam/course/2/pod-ip.txt ]; then
  echo "Success: pod-ip.txt exists and is not empty"; exit 0
else
  echo "Error: /tmp/exam/course/2/pod-ip.txt missing or empty"; exit 1
fi
