#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=helmyard
DIR=/home/candidate/exam/q13
WORK=$(mktemp -d 2>/dev/null || echo /tmp/q13-chart-$$)
mkdir -p "$WORK"

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# ---- clean state (idempotent re-runs) ----
for r in $(helm -n "$NS" list -a -q 2>/dev/null); do
  helm -n "$NS" uninstall "$r" >/dev/null 2>&1 || true
done
kubectl -n "$NS" delete secret -l owner=helm --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete deployment,service,serviceaccount -l app.kubernetes.io/managed-by=Helm --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap -l app.kubernetes.io/managed-by=Helm --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

# ---- local chart depot-web 0.1.0 ----
C="$WORK/depot-web"
mkdir -p "$C/templates"
cat > "$C/Chart.yaml" <<'EOF'
apiVersion: v2
name: depot-web
description: Depot information web front-end of the Transit Authority
type: application
version: 0.1.0
appVersion: "1.25"
EOF
cat > "$C/values.yaml" <<'EOF'
replicaCount: 1

image:
  repository: nginx
  tag: "1.25"
  pullPolicy: IfNotPresent

podAnnotations: {}
podLabels: {}

service:
  type: ClusterIP
  port: 80

resources:
  requests:
    cpu: 10m
    memory: 16Mi
EOF
cat > "$C/templates/_helpers.tpl" <<'EOF'
{{- define "depot-web.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* The workload objects are named after the release */}}
{{- define "depot-web.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "depot-web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "depot-web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "depot-web.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "depot-web.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
EOF
cat > "$C/templates/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "depot-web.fullname" . }}
  labels:
    {{- include "depot-web.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "depot-web.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "depot-web.selectorLabels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      containers:
        - name: web
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF
cat > "$C/templates/service.yaml" <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: {{ include "depot-web.fullname" . }}
  labels:
    {{- include "depot-web.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "depot-web.selectorLabels" . | nindent 4 }}
EOF
cat > "$C/templates/NOTES.txt" <<'EOF'
{{ include "depot-web.fullname" . }} ({{ .Chart.Name }} {{ .Chart.Version }}) is running image {{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}.
EOF
helm package "$C" -d "$DIR" >/dev/null 2>&1 || true

# ---- chart depot-web 0.2.0: new default image and a departure-board ConfigMap ----
sed -i 's/^version: .*/version: 0.2.0/; s/^appVersion: .*/appVersion: "1.26"/' "$C/Chart.yaml"
sed -i 's/^  tag: "1.25"/  tag: "1.26"/' "$C/values.yaml"
cat >> "$C/values.yaml" <<'EOF'

# Departure board (new in 0.2.0)
board:
  refreshSeconds: 30
  title: "Yard departures"
EOF
cat > "$C/templates/board-configmap.yaml" <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "depot-web.fullname" . }}-board
  labels:
    {{- include "depot-web.labels" . | nindent 4 }}
data:
  refreshSeconds: {{ .Values.board.refreshSeconds | quote }}
  title: {{ .Values.board.title | quote }}
EOF
helm package "$C" -d "$DIR" >/dev/null 2>&1 || true

V1="$DIR/depot-web-0.1.0.tgz"
V2="$DIR/depot-web-0.2.0.tgz"

# ---- releases ----
# route-planner: 0.1.0 with custom values (the values file is not kept)
cat > "$WORK/route-planner.yaml" <<'EOF'
replicaCount: 2
podAnnotations:
  transit.example/zone: north-yard
podLabels:
  lane: express
resources:
  limits:
    memory: 64Mi
EOF
helm -n "$NS" install route-planner "$V1" -f "$WORK/route-planner.yaml" >/dev/null 2>&1 || true

# fare-cache: already on 0.2.0
helm -n "$NS" install fare-cache "$V2" --set podLabels.lane=cache >/dev/null 2>&1 || true

# crew-roster: a failed upgrade in its history, rolled back since (currently deployed)
helm -n "$NS" install crew-roster "$V1" --set podLabels.lane=crew >/dev/null 2>&1 || true
helm -n "$NS" upgrade crew-roster "$V1" --reuse-values --set replicaCount=-1 >/dev/null 2>&1 || true
helm -n "$NS" rollback crew-roster 1 >/dev/null 2>&1 || true

# old-signage: uninstalled, history kept
helm -n "$NS" install old-signage "$V1" >/dev/null 2>&1 || true
helm -n "$NS" uninstall old-signage --keep-history >/dev/null 2>&1 || true

# stop-indexer: install with a non-existent image tag and --wait -> status failed
cat > "$WORK/stop-indexer.yaml" <<'EOF'
replicaCount: 3
image:
  tag: "1.26.99"
podLabels:
  lane: local
EOF
helm -n "$NS" install stop-indexer "$V1" -f "$WORK/stop-indexer.yaml" --wait --timeout 25s >/dev/null 2>&1 || true

rm -rf "$WORK"
chown -R candidate: "$DIR" >/dev/null 2>&1 || true

echo "Setup complete for Question 13"
exit 0
