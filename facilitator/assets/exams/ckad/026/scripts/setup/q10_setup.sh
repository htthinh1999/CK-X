#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=permits
D=/home/candidate/exam/q10

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf "$D"
mkdir -p "$D/certs/keys"

# Reset: remove what a previous attempt created
kubectl -n "$NS" delete pod permit-check --ignore-not-found --grace-period=1 --wait=true --timeout=60s >/dev/null 2>&1 || true
kubectl -n "$NS" delete secret permits-registry permits-tls --ignore-not-found >/dev/null 2>&1 || true

# Certificate and three candidate keys (only one of them belongs to the certificate)
cat > "$D/certs/gate.crt" <<'PEM'
-----BEGIN CERTIFICATE-----
MIIB/jCCAaSgAwIBAgIUWF3Q3vddoqHpgNwN2UWGVFI/n74wCgYIKoZIzj0EAwIw
QTEaMBgGA1UECgwRVHJhbnNpdCBBdXRob3JpdHkxIzAhBgNVBAMMGmdhdGUucGVy
bWl0cy50cmFuc2l0LmxvY2FsMB4XDTI2MDkyMzAzMjUzMFoXDTM2MDkyMDAzMjUz
MFowQTEaMBgGA1UECgwRVHJhbnNpdCBBdXRob3JpdHkxIzAhBgNVBAMMGmdhdGUu
cGVybWl0cy50cmFuc2l0LmxvY2FsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE
vXN/3jjWYfFiUNGi+pRWXHc1bFRafxMfHKDZORJET2a1nv0pUcf+okqNaVo6eZFi
+KBZGiBH8+TgBR7mnurjiaN6MHgwHQYDVR0OBBYEFNrc+Dle/jga3iM2PuE0VO4V
wMFGMB8GA1UdIwQYMBaAFNrc+Dle/jga3iM2PuE0VO4VwMFGMA8GA1UdEwEB/wQF
MAMBAf8wJQYDVR0RBB4wHIIaZ2F0ZS5wZXJtaXRzLnRyYW5zaXQubG9jYWwwCgYI
KoZIzj0EAwIDSAAwRQIgEkMib5XWfzhocQgPmBNZ7V7vsowdWDePQtPFokmIjpAC
IQCWZLKHeRvrPJ1xftlxGfj+3QGLT5DUCdWN3x5Alv0C1A==
-----END CERTIFICATE-----
PEM
cat > "$D/certs/keys/a1f3.key" <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIPU3tzxm/aVwyrP5jud6gwT1noRPxlbgFCn89v0hgOptoAoGCCqGSM49
AwEHoUQDQgAE36Ew+ox3yvN3qw3nfUouhIYX2o1JkYOQJUSPl6ibWIhl4WmyvqvQ
hDnmvRmzBh0wzjqMcRkyjbK5IMPZ1MbXIw==
-----END EC PRIVATE KEY-----
PEM
cat > "$D/certs/keys/b7c2.key" <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIEeJCWAW1CWu7AAagRvgy57ZYqQxiTCaTVUjyQYvQj22oAoGCCqGSM49
AwEHoUQDQgAEvXN/3jjWYfFiUNGi+pRWXHc1bFRafxMfHKDZORJET2a1nv0pUcf+
okqNaVo6eZFi+KBZGiBH8+TgBR7mnurjiQ==
-----END EC PRIVATE KEY-----
PEM
cat > "$D/certs/keys/c9d0.key" <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIL/PGTpxO+/Hn3VmojrgCknnglGtYsFfUC9wrwsx2X7loAoGCCqGSM49
AwEHoUQDQgAE89WSa/h9mkYkkwgQr2246a0US5ayhZRDJHGBK/vNVE3PoMcr/gf+
UGg4/G6lu1YJ8eQJb0A1oPWNYYuHOELftA==
-----END EC PRIVATE KEY-----
PEM

# The namespace's default ServiceAccount (created by the controller) must exist first
for i in $(seq 1 60); do
  kubectl -n "$NS" get serviceaccount default >/dev/null 2>&1 && break
  sleep 1
done

cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: v1
kind: Secret
metadata:
  name: legacy-pull
  namespace: permits
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"registry.legacy.transit.local":{"username":"legacy","password":"retired-2024","auth":"bGVnYWN5OnJldGlyZWQtMjAyNA=="}}}'
---
apiVersion: v1
kind: Secret
metadata:
  name: permits-db
  namespace: permits
type: Opaque
stringData:
  username: permits
  password: s3cr3t-db
---
apiVersion: v1
kind: Secret
metadata:
  name: permits-ci-pull
  namespace: permits
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"ci.transit.local":{"username":"ci","password":"ci-only","auth":"Y2k6Y2ktb25seQ=="}}}'
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: permits-ci
  namespace: permits
imagePullSecrets:
- name: permits-ci-pull
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: permits-batch
  namespace: permits
YAML

# default SA starts with exactly one pull secret
kubectl -n "$NS" patch serviceaccount default --type=json \
  -p '[{"op":"add","path":"/imagePullSecrets","value":[{"name":"legacy-pull"}]}]' >/dev/null

# Pod created now: it only receives the legacy pull secret from the ServiceAccount
# (short pause so the admission plugin's ServiceAccount cache has seen the patch)
sleep 2
cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: v1
kind: Pod
metadata:
  name: permit-check
  namespace: permits
  labels:
    app: permit-check
spec:
  containers:
  - name: pause
    image: registry.k8s.io/pause:3.9
YAML
kubectl -n "$NS" wait --for=condition=Ready pod/permit-check --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 10"
exit 0
