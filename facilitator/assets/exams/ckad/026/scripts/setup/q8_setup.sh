#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=lostproperty
D=/home/candidate/exam/q8

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf "$D"
mkdir -p "$D"

# Reset: remove everything a previous attempt may have changed
kubectl -n "$NS" delete deployment claims-desk claims-archive claims-kiosk --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap desk-config desk-config-draft archive-config kiosk-config --ignore-not-found >/dev/null 2>&1 || true

cat > "$D/desk-settings.properties" <<'EOF'
# Approved settings for the lost-property desk (change ticket LP-2291)
desk.region=north-concourse
desk.hours=06:00-22:00
retention.days=90
contact.channel=desk-ops
claim.window=45d
ledger.path=/var/ledger/claims.db
notify.webhook=http://notify.lostproperty.svc:8080/hook
audit.level=verbose
EOF

cat <<'YAML' | kubectl apply -f - >/dev/null
apiVersion: v1
kind: ConfigMap
metadata:
  name: desk-config
  namespace: lostproperty
data:
  desk.region: north-concourse
  desk.hours: "06:00-22:00"
  retention.days: "90"
  contact.channel: desk-ops
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: desk-config-draft
  namespace: lostproperty
data:
  desk.region: north-concourse
  desk.hours: "06:00-22:00"
  retention.days: "30"
  contact.channel: desk-ops
  claim.window: 14d
  ledger.path: /tmp/ledger.db
  notify.webhook: http://localhost/hook
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: archive-config
  namespace: lostproperty
data:
  archive.bucket: lp-archive
  claim.window: 365d
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kiosk-config
  namespace: lostproperty
data:
  kiosk.banner: "Report lost items at desk 3"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claims-desk
  namespace: lostproperty
spec:
  replicas: 2
  selector:
    matchLabels:
      app: claims-desk
  template:
    metadata:
      labels:
        app: claims-desk
    spec:
      containers:
      - name: desk
        image: nginx:1.25
        env:
        - name: DESK_REGION
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: desk.region
        - name: RETENTION_DAYS
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: retention.days
        - name: CLAIM_WINDOW
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: claim.window
        - name: NOTIFY_WEBHOOK
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: notify.webhook
              optional: true
      - name: ledger
        image: busybox:1.36
        command: ["sh", "-c", "while true; do echo \"ledger at $LEDGER_PATH open $DESK_HOURS\"; sleep 60; done"]
        env:
        - name: DESK_HOURS
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: desk.hours
        - name: LEDGER_PATH
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: ledger.path
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claims-archive
  namespace: lostproperty
spec:
  replicas: 1
  selector:
    matchLabels:
      app: claims-archive
  template:
    metadata:
      labels:
        app: claims-archive
    spec:
      containers:
      - name: archive
        image: busybox:1.36
        command: ["sh", "-c", "while true; do sleep 3600; done"]
        env:
        - name: CLAIM_WINDOW
          valueFrom:
            configMapKeyRef:
              name: archive-config
              key: claim.window
        - name: ARCHIVE_BUCKET
          valueFrom:
            configMapKeyRef:
              name: archive-config
              key: archive.bucket
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claims-kiosk
  namespace: lostproperty
spec:
  replicas: 1
  selector:
    matchLabels:
      app: claims-kiosk
  template:
    metadata:
      labels:
        app: claims-kiosk
    spec:
      containers:
      - name: kiosk
        image: nginx:1.25
        envFrom:
        - configMapRef:
            name: kiosk-config
        env:
        - name: DESK_REGION
          valueFrom:
            configMapKeyRef:
              name: desk-config
              key: desk.region
YAML

# Remember which Deployment object the student has to leave alone
uid=$(kubectl -n "$NS" get deployment claims-desk -o jsonpath='{.metadata.uid}' 2>/dev/null)
kubectl annotate namespace "$NS" "transit.example.com/q8-desk-uid=$uid" --overwrite >/dev/null 2>&1 || true

echo "Setup complete for Question 8"
exit 0
