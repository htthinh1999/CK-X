#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace ocean --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/2
cat > /tmp/exam/course/2/Dockerfile <<'EOF'
FROM golang:1.20-alpine
COPY . /app
WORKDIR /app
RUN go build -o app main.go
CMD ["./app"]
EOF
cat > /tmp/exam/course/2/main.go <<'EOF'
package main
import (
	"fmt"
	"time"
)
func main() {
	for {
		fmt.Println("App running")
		time.Sleep(5 * time.Second)
	}
}
EOF
echo "Setup complete for Question 2"
exit 0
