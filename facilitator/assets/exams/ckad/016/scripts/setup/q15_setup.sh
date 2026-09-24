#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace surge --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/15/chart/templates

cat > /tmp/exam/course/15/chart/Chart.yaml <<'YAML'
apiVersion: v2
name: thunder-web
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
YAML

cat > /tmp/exam/course/15/chart/values.yaml <<'YAML'
replicaCount: 1
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.16.0"
YAML

cat > /tmp/exam/course/15/chart/templates/deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "thunder-web.fullname" . }}
  labels:
    app: {{ include "thunder-web.name" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "thunder-web.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "thunder-web.name" . }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
YAML

cat > /tmp/exam/course/15/chart/templates/_helpers.tpl <<'YAML'
{{- define "thunder-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "thunder-web.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
YAML

# Remove any previously-rendered output so the exists-check is not auto-passed
rm -f /tmp/exam/course/15/output.yaml 2>/dev/null || true
echo "Setup complete for Question 15"
exit 0
