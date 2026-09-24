#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace vault --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

D=/home/candidate/exam/q3
rm -rf "$D"
mkdir -p "$D"

# Reset objects the student creates (idempotent re-runs)
kubectl -n vault delete pod cert-loader --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n vault delete secret observatory-tls --ignore-not-found >/dev/null 2>&1 || true

cat > "$D/signing.key" <<'EOF'
-----BEGIN OBSERVATORY SIGNING KEY-----
b2JzZXJ2YXRvcnktc2lnbmluZy1rZXktcHJhY3RpY2Utb25seS0wMQ==
dGVsZXNjb3BlLWFycmF5LW5vcnRoLXJpZGdlLWtleS1tYXRlcmlhbA==
-----END OBSERVATORY SIGNING KEY-----
EOF

cat > "$D/ca.crt" <<'EOF'
-----BEGIN CERTIFICATE-----
b2JzZXJ2YXRvcnktcm9vdC1jYS1wcmFjdGljZS1vbmx5LTIwMjY=
Y249T2JzZXJ2YXRvcnkgUm9vdCBDQSxvPU5vcnRoIFJpZGdl
-----END CERTIFICATE-----
EOF

echo "Setup complete for Question 3"
exit 0
