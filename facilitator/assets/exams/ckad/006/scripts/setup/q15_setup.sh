#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl apply -f - <<'EOF' >/dev/null 2>&1 || true
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: default
spec:
  selector:
    app: api
  ports:
    - port: 8080
      targetPort: 9090
EOF
mkdir -p /tmp/exam/course/15
cat > /tmp/exam/course/15/fix-ingress.yaml <<'EOF'
# Q15: Ingress with invalid pathType
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: default
spec:
  rules:
    - http:
        paths:
          - path: /api
            pathType: InvalidType
            backend:
              service:
                name: api-svc
                port:
                  number: 8080
EOF
echo "Setup complete for Question 15"
exit 0
