#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=ticketing
DIR=/home/candidate/exam/q1

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs, drops labels added by a previous attempt)
kubectl -n "$NS" delete pod --all --grace-period=0 --force --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete secret --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap fare-rules --ignore-not-found >/dev/null 2>&1 || true

rm -rf "$DIR" && mkdir -p "$DIR"

kubectl apply -f - >/dev/null <<'EOF'
# ---------------- Opaque Secrets ----------------
apiVersion: v1
kind: Secret
metadata:
  name: barrier-api-key
  namespace: ticketing
  labels: {app: gates}
type: Opaque
stringData:
  API_KEY: bk-2019-0f3a
---
apiVersion: v1
kind: Secret
metadata:
  name: barrier-api-key-v2
  namespace: ticketing
  labels: {app: gates}
type: Opaque
stringData:
  API_KEY: bk-2024-77c1
---
apiVersion: v1
kind: Secret
metadata:
  name: fare-rules
  namespace: ticketing
  labels: {app: fares}
type: Opaque
stringData:
  PEAK_MULTIPLIER: "1.4"
---
apiVersion: v1
kind: Secret
metadata:
  name: ledger-db-creds
  namespace: ticketing
  labels: {app: ledger, lifecycle: orphaned}
  annotations:
    audit.transit.io/checked: "2023-11-02"
type: Opaque
stringData:
  DB_USER: ledger
  DB_PASSWORD: s3cr3t-ledger
---
apiVersion: v1
kind: Secret
metadata:
  name: night-bus-token
  namespace: ticketing
  labels: {app: ledger}
type: Opaque
stringData:
  token: nb-5521
---
apiVersion: v1
kind: Secret
metadata:
  name: turnstile-firmware-key
  namespace: ticketing
  labels: {app: gates}
type: Opaque
stringData:
  firmware.key: tfk-a91
---
apiVersion: v1
kind: Secret
metadata:
  name: validator-hmac
  namespace: ticketing
  labels: {app: fares}
type: Opaque
stringData:
  hmac: 9c1e2f
---
apiVersion: v1
kind: Secret
metadata:
  name: legacy-smartcard-key
  namespace: ticketing
  labels: {app: gates}
type: Opaque
stringData:
  key: sc-2017
---
apiVersion: v1
kind: Secret
metadata:
  name: promo-codes-2024
  namespace: ticketing
  labels: {app: portal}
type: Opaque
stringData:
  codes: SPRING24,SUMMER24
---
# ---------------- other Secret types ----------------
apiVersion: v1
kind: Secret
metadata:
  name: ticketing-tls
  namespace: ticketing
  labels: {app: portal}
type: kubernetes.io/tls
stringData:
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    MIIBmTCCAT+gAwIBAgIUSIPURpKMl8qTsaVreuXjvcyhpVEwCgYIKoZIzj0EAwIw
    IjEgMB4GA1UEAwwXdGlja2V0aW5nLnRyYW5zaXQubG9jYWwwHhcNMjYwOTIzMDMy
    OTA1WhcNMzYwOTIwMDMyOTA1WjAiMSAwHgYDVQQDDBd0aWNrZXRpbmcudHJhbnNp
    dC5sb2NhbDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABPk8QBdDROYPE4MYtZ4B
    9uF1kYJe+N5r9yeuUg8fEj7/7Cv3FreopYlUbPNMwxd6B6XgDfwqxGb/aU5BUiec
    Sm2jUzBRMB0GA1UdDgQWBBTdJTJLdKh9mUay4/dpyyYaFE9H8TAfBgNVHSMEGDAW
    gBTdJTJLdKh9mUay4/dpyyYaFE9H8TAPBgNVHRMBAf8EBTADAQH/MAoGCCqGSM49
    BAMCA0gAMEUCIQCR2OB2JHwhcJl6hBvHjOOTy00AZshdfm0rctVkTc9xEAIgBTNN
    0jEa8cdH3pSnKYj4nIHeLWkx5gQu3PSsUkds0Cw=
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgbP8Ab/EQQu0lzlE5
    aKOE4EGaUn/C2Ww1Xyxi9G1bHIihRANCAAT5PEAXQ0TmDxODGLWeAfbhdZGCXvje
    a/cnrlIPHxI+/+wr9xa3qKWJVGzzTMMXegel4A38KsRm/2lOQVInnEpt
    -----END PRIVATE KEY-----
---
apiVersion: v1
kind: Secret
metadata:
  name: portal-tls
  namespace: ticketing
  labels: {app: portal}
type: kubernetes.io/tls
stringData:
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    MIIBkjCCATmgAwIBAgIUNuTgG3CsiS6ZmpyIiEzRLiat530wCgYIKoZIzj0EAwIw
    HzEdMBsGA1UEAwwUcG9ydGFsLnRyYW5zaXQubG9jYWwwHhcNMjYwOTIzMDMyOTA1
    WhcNMzYwOTIwMDMyOTA1WjAfMR0wGwYDVQQDDBRwb3J0YWwudHJhbnNpdC5sb2Nh
    bDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCsypBEZBMP5XiODaKniSfq7OV1m
    oZ2A1DTYQOQ/BM++vOm/hbQM4jhTAeVWSIUpaJYbO6/gm76WHA/HitwJTz+jUzBR
    MB0GA1UdDgQWBBQqnf/gqkelnd+/nDdqNj37034m6zAfBgNVHSMEGDAWgBQqnf/g
    qkelnd+/nDdqNj37034m6zAPBgNVHRMBAf8EBTADAQH/MAoGCCqGSM49BAMCA0cA
    MEQCIARNYH3Uk7X4n/xDfs9MmAbW0OwK0jekoplGdYF4VpfxAiAFX7B4O37jF2r6
    y0R9cmnGoteTiv1E8CD/uVj+RUUYmA==
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgDQVhU0APpR4mP5/y
    MJhYp9XgPWpIhduKSidVCQ5Sdo6hRANCAAQrMqQRGQTD+V4jg2ip4kn6uzldZqGd
    gNQ02EDkPwTPvrzpv4W0DOI4UwHlVkiFKWiWGzuv4Ju+lhwPx4rcCU8/
    -----END PRIVATE KEY-----
---
apiVersion: v1
kind: Secret
metadata:
  name: regcred-mirror
  namespace: ticketing
  labels: {app: portal}
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"registry.transit.local":{"username":"ci","password":"mirror-pw","auth":"Y2k6bWlycm9yLXB3"}}}'
---
apiVersion: v1
kind: Secret
metadata:
  name: regcred-old
  namespace: ticketing
  labels: {app: portal}
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"old-registry.transit.local":{"username":"ci","password":"old-pw","auth":"Y2k6b2xkLXB3"}}}'
---
apiVersion: v1
kind: Secret
metadata:
  name: kiosk-admin
  namespace: ticketing
  labels: {app: kiosk}
type: kubernetes.io/basic-auth
stringData:
  username: kiosk
  password: kiosk-pw
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: fare-rules
  namespace: ticketing
  labels: {app: fares}
data:
  PEAK_START: "07:00"
  PEAK_END: "09:30"
---
# ---------------- Pods ----------------
apiVersion: v1
kind: Pod
metadata:
  name: gate-controller
  namespace: ticketing
  labels: {app: gates}
spec:
  containers:
  - name: controller
    image: registry.k8s.io/pause:3.9
    env:
    - name: BARRIER_API_KEY
      valueFrom:
        secretKeyRef:
          name: barrier-api-key-v2
          key: API_KEY
---
apiVersion: v1
kind: Pod
metadata:
  name: ledger-sync
  namespace: ticketing
  labels: {app: ledger}
spec:
  initContainers:
  - name: fetch-token
    image: busybox:1.36
    command: ["sh", "-c", "test -n \"$NIGHT_TOKEN\""]
    env:
    - name: NIGHT_TOKEN
      valueFrom:
        secretKeyRef:
          name: night-bus-token
          key: token
  containers:
  - name: sync
    image: registry.k8s.io/pause:3.9
    envFrom:
    - secretRef:
        name: ledger-db-creds
      prefix: LEDGER_
---
apiVersion: v1
kind: Pod
metadata:
  name: turnstile-agent
  namespace: ticketing
  labels: {app: gates}
  annotations:
    transit.io/migrated-from: legacy-smartcard-key
spec:
  containers:
  - name: agent
    image: registry.k8s.io/pause:3.9
    volumeMounts:
    - name: firmware
      mountPath: /etc/firmware
      readOnly: true
  volumes:
  - name: firmware
    secret:
      secretName: turnstile-firmware-key
---
apiVersion: v1
kind: Pod
metadata:
  name: fare-engine
  namespace: ticketing
  labels: {app: fares}
spec:
  containers:
  - name: engine
    image: registry.k8s.io/pause:3.9
    envFrom:
    - configMapRef:
        name: fare-rules
    volumeMounts:
    - name: signing
      mountPath: /etc/signing
      readOnly: true
  volumes:
  - name: signing
    projected:
      sources:
      - secret:
          name: validator-hmac
      - downwardAPI:
          items:
          - path: pod-name
            fieldRef:
              fieldPath: metadata.name
---
apiVersion: v1
kind: Pod
metadata:
  name: portal-web
  namespace: ticketing
  labels: {app: portal}
spec:
  imagePullSecrets:
  - name: regcred-mirror
  containers:
  - name: web
    image: registry.k8s.io/pause:3.9
    volumeMounts:
    - name: tls
      mountPath: /etc/tls
      readOnly: true
    - name: promo-codes-2024
      mountPath: /var/cache/promo
  volumes:
  - name: tls
    secret:
      secretName: portal-tls
  - name: promo-codes-2024
    emptyDir: {}
EOF

kubectl -n "$NS" wait --for=condition=Ready pod --all --timeout=120s >/dev/null 2>&1 || true

echo "Setup complete for Question 1"
exit 0
