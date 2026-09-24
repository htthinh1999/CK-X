#bin/bash

# Validate namespace if present then return 0 else return 1
kubectl get namespace dev
if [ $? -eq 0 ]; then
    echo "Namespace dev is present"
    exit 0
else
    echo "Namespace dev is not present"
    exit 1
fi