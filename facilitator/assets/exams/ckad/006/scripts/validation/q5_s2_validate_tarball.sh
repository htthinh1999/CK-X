#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/5/my-app.tar" ]; then echo "Success: tarball exists at /tmp/exam/course/5/my-app.tar"; exit 0; else echo "Error: tarball /tmp/exam/course/5/my-app.tar not found"; exit 1; fi
