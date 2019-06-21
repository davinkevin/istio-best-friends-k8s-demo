#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

# Create the cluster with this command
# gcloud beta container --project "istio-csm" clusters create "istio-k8s-bff" --zone "us-central1-a" --username "admin" --cluster-version "1.12.7-gke.10" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-stackdriver-kubernetes --no-enable-ip-alias --network "projects/istio-csm/global/networks/default" --subnetwork "projects/istio-csm/regions/us-central1/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

curl -L https://git.io/getLatestIstio | sh -
set ISTIO_FOLDER (ls | grep istio | tail -n 1)
ls $ISTIO_FOLDER/install/kubernetes/helm/istio-init/files/crd*yaml | xargs -n1 -P 1 -I  @ kubectl apply -f @
sleep 5
kubectl apply -f $ISTIO_FOLDER/install/kubernetes/istio-demo.yaml

echo "Setting the Auto-sidecar injection"
kubectl --overwrite=true label namespace default istio-injection=enabled

echo "Building Search service"
./mvnw -f search/pom.xml compile jib:build
kubectl apply -f search/src/main/k8s/search.v1.yaml

echo "Building UI service"
./mvnw -f ui/pom.xml compile jib:build
kubectl apply -f ui/src/main/k8s/ui.v1.yaml
