#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

ip=$(cat /tmp/exam/course/6/pod-ip.txt 2>/dev/null)
if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Success: valid IPv4 format ($ip)"; exit 0
else
  echo "Error: invalid IP format ('$ip')"; exit 1
fi
