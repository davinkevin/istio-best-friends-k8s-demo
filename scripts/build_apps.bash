#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

echo "Setting the Auto-sidecar injection"
kubectl --overwrite=true label namespace default istio-injection=enabled

echo "Building Search service"
./mvnw -f search/pom.xml compile jib:build
kubectl apply -f search/src/main/k8s/search.v1.yaml

echo "Building UI service"
./mvnw -f ui/pom.xml compile jib:build
kubectl apply -f ui/src/main/k8s/ui.v1.yaml
