#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/19/permissions.txt" ]; then echo "Success: file /tmp/exam/course/19/permissions.txt has content"; exit 0; else echo "Error: file /tmp/exam/course/19/permissions.txt is empty or missing"; exit 1; fi
