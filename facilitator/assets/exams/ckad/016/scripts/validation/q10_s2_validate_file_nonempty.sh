#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/10/events.txt"
if [ -s "$f" ]; then echo "Success: events.txt is not empty"; exit 0; fi
echo "Error: events.txt is empty or missing"; exit 1
