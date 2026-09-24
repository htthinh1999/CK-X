#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace flare --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/15
if [ ! -f /tmp/exam/course/15/tls.crt ] || [ ! -f /tmp/exam/course/15/tls.key ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /tmp/exam/course/15/tls.key \
    -out /tmp/exam/course/15/tls.crt \
    -subj "/CN=web.flare.example.com" >/dev/null 2>&1 || true
fi
echo "Setup complete for Question 15"
exit 0
