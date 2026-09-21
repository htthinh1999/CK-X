#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace nebula --dry-run=client -o yaml | kubectl apply -f - || true

helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null
helm repo update 2>/dev/null

# Install revision 1 (good) if not already present, then upgrade to a broken
# revision so the candidate must roll back to revision 1.
if ! helm status api-release -n nebula >/dev/null 2>&1; then
  helm install api-release bitnami/nginx -n nebula \
    --set service.type=ClusterIP --set replicaCount=1 \
    --wait=false --timeout 120s 2>/dev/null || true
fi

# Only create the broken revision 2 if we are still at revision 1
current_rev=$(helm history api-release -n nebula -o json 2>/dev/null | jq -r '.[-1].revision' 2>/dev/null)
if [ "$current_rev" == "1" ]; then
  helm upgrade api-release bitnami/nginx -n nebula \
    --set image.tag="nonexistent-tag-12345" --reuse-values --wait=false 2>/dev/null || true
fi

echo "Setup complete for Question 5"
exit 0
