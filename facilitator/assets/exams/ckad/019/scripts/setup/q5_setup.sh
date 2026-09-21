#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace garrison --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/5
# Create the battle-chart if not present (default nginx chart)
if [ ! -d /tmp/exam/course/5/battle-chart ]; then
  helm create /tmp/exam/course/5/battle-chart >/dev/null 2>&1 || true
fi
# Pre-install the battle-web release with replicaCount=1 (student upgrades to 3)
helm status battle-web -n garrison >/dev/null 2>&1 || \
  helm install battle-web /tmp/exam/course/5/battle-chart -n garrison --set replicaCount=1 --wait --timeout 120s >/dev/null 2>&1 || \
  helm install battle-web /tmp/exam/course/5/battle-chart -n garrison --set replicaCount=1 >/dev/null 2>&1 || true

echo "Setup complete for Question 5"
exit 0
