#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace berth --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Reset: remove any releases of this question.
for r in tugboat pilot-legacy harbormaster; do
  helm uninstall "$r" -n berth >/dev/null 2>&1 || true
done

# Local chart (no repositories): helm create + pin the nginx tag to 1.25.
rm -rf /home/candidate/exam/q4 && mkdir -p /home/candidate/exam/q4
(cd /home/candidate/exam/q4 && helm create dockyard >/dev/null 2>&1) || true
sed -i 's/^\(  tag: \)""/\1"1.25"/' /home/candidate/exam/q4/dockyard/values.yaml 2>/dev/null || true

CHART=/home/candidate/exam/q4/dockyard
helm install tugboat "$CHART" -n berth --set podAnnotations.owner=berth-ops >/dev/null 2>&1 || true
helm install pilot-legacy "$CHART" -n berth >/dev/null 2>&1 || true

kubectl -n berth wait --for=condition=Available deployment --all --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 4"
exit 0
