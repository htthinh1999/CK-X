#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
se=$(kubectl get pod selinux-pod -n cadence -o jsonpath='{.spec.securityContext.seLinuxOptions.level}' 2>/dev/null)
if [ "$se" == "s0:c123,c456" ]; then
  echo "Success: SELinux level is s0:c123,c456"; exit 0
fi
echo "Error: SELinux level is '$se', expected s0:c123,c456"; exit 1
