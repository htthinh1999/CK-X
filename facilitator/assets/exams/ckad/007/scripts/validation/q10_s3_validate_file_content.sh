#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/10/debug-output.txt" ]; then echo "Success: file /tmp/exam/course/10/debug-output.txt has content"; exit 0; else echo "Error: file /tmp/exam/course/10/debug-output.txt is empty or missing"; exit 1; fi
