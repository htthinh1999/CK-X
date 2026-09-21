#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/19/permissions.txt" ]; then echo "Success: file /tmp/exam/course/19/permissions.txt exists"; exit 0; else echo "Error: file /tmp/exam/course/19/permissions.txt not found"; exit 1; fi
