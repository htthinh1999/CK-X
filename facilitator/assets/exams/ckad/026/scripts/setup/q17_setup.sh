#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=manifests
DIR=/home/candidate/exam/q17

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

kubectl apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: routes.transit.example.com
spec:
  group: transit.example.com
  scope: Namespaced
  names:
    kind: Route
    listKind: RouteList
    plural: routes
    singular: route
    shortNames: ["trt"]
  versions:
    - name: v1
      served: true
      storage: true
      additionalPrinterColumns:
        - name: Line
          type: string
          jsonPath: .spec.line
        - name: Mode
          type: string
          jsonPath: .spec.mode
        - name: Stops
          type: integer
          jsonPath: .spec.stops
        - name: Age
          type: date
          jsonPath: .metadata.creationTimestamp
      schema:
        openAPIV3Schema:
          type: object
          description: A passenger route operated by the Transit Authority.
          properties:
            spec:
              type: object
              description: Timetable data of the route.
              required: ["line", "mode", "stops"]
              properties:
                line:
                  type: string
                  pattern: '^[A-Z]{1,2}[0-9]{1,3}$'
                  description: Public line code shown on the vehicles, e.g. T4 or NB31.
                mode:
                  type: string
                  enum: ["bus", "tram", "metro", "ferry"]
                  description: Vehicle type used on the route.
                stops:
                  type: integer
                  minimum: 2
                  maximum: 80
                  description: Number of stops served, both termini included.
                depot:
                  type: string
                  description: Depot or pier that supplies the vehicles.
                serviceClass:
                  type: string
                  enum: ["C1", "C3", "C5", "C8"]
                  description: >-
                    Timetable class code. C1 = local all-stops service,
                    C3 = limited-stop express, C5 = night network (00:30-05:00),
                    C8 = school days only.
                frequencyMinutes:
                  type: integer
                  minimum: 1
                  maximum: 120
                  description: Minutes between two departures in the base timetable.
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: routes.freight.example.com
spec:
  group: freight.example.com
  scope: Namespaced
  names:
    kind: Route
    listKind: RouteList
    plural: routes
    singular: route
    shortNames: ["frt"]
  versions:
    - name: v1
      served: true
      storage: true
      additionalPrinterColumns:
        - name: Origin
          type: string
          jsonPath: .spec.origin
        - name: Destination
          type: string
          jsonPath: .spec.destination
      schema:
        openAPIV3Schema:
          type: object
          description: A freight corridor leased to a rail operator.
          properties:
            spec:
              type: object
              required: ["origin", "destination"]
              properties:
                origin:
                  type: string
                destination:
                  type: string
                tonnage:
                  type: integer
                stops:
                  type: integer
YAML

kubectl wait --for=condition=Established crd/routes.transit.example.com crd/routes.freight.example.com --timeout=60s >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete routes.transit.example.com --all --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete routes.freight.example.com --all --ignore-not-found >/dev/null 2>&1 || true

# retried: right after the CRDs become Established, API discovery can lag briefly
for i in 1 2 3 4 5; do
kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' && break
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: t4-harbour
  namespace: manifests
spec:
  line: T4
  mode: tram
  stops: 18
  depot: riverside
  serviceClass: C1
  frequencyMinutes: 8
---
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: b12-airport
  namespace: manifests
spec:
  line: B12
  mode: bus
  stops: 9
  depot: north
  serviceClass: C3
  frequencyMinutes: 15
---
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: m2-crosstown
  namespace: manifests
spec:
  line: M2
  mode: metro
  stops: 22
  depot: central
  serviceClass: C1
  frequencyMinutes: 4
---
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: nb31-late
  namespace: manifests
spec:
  line: NB31
  mode: bus
  stops: 27
  depot: north
  serviceClass: C5
  frequencyMinutes: 30
---
apiVersion: transit.example.com/v1
kind: Route
metadata:
  name: b7-schools
  namespace: manifests
spec:
  line: B7
  mode: bus
  stops: 14
  depot: west
  serviceClass: C8
---
apiVersion: freight.example.com/v1
kind: Route
metadata:
  name: coal-west
  namespace: manifests
spec:
  origin: westport
  destination: power-station
  tonnage: 3200
  stops: 2
---
apiVersion: freight.example.com/v1
kind: Route
metadata:
  name: grain-east
  namespace: manifests
spec:
  origin: silo-7
  destination: eastern-docks
  tonnage: 1800
  stops: 3
---
apiVersion: freight.example.com/v1
kind: Route
metadata:
  name: steel-north
  namespace: manifests
spec:
  origin: mill-2
  destination: north-yard
  tonnage: 2600
  stops: 4
YAML
  sleep 2
done

echo "Setup complete for Question 17"
exit 0
