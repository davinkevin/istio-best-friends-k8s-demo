#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

# Create the cluster with this command
# gcloud beta container --project "istio-meilleur-ami-de-k8s" clusters create "istio-k8s-bff" --zone "us-central1-a" --username "admin" --cluster-version "1.10.12-gke.1" --machine-type "n1-standard-4" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-stackdriver-kubernetes --no-enable-ip-alias --network "projects/istio-meilleur-ami-de-k8s/global/networks/default" --subnetwork "projects/istio-meilleur-ami-de-k8s/regions/us-central1/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

echo "Use my personal mail"
gcloud config set account davin.kevin@gmail.com
echo "create a role for my user in the cluster"
kubectl create clusterrolebinding cluster-admin-binding \
                  --clusterrole=cluster-admin \
                  --user=(gcloud config get-value core/account)

curl -L https://git.io/getLatestIstio | sh -
kubectl apply -f istio-1.0.5/install/kubernetes/helm/istio/templates/crds.yaml
sleep 10
kubectl apply -f istio-1.0.5/install/kubernetes/istio-demo.yaml

echo "Installation of Kiali"
curl -L http://git.io/getLatestKialiKubernetes | bash
# bash <(curl -L http://git.io/getLatestKialiKubernetes)

echo "Installation of Docker credential GCR"
export VERSION=1.5.0 && export OS=linux && export ARCH=amd64
curl -qs -L "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" | tar zxv > docker-credential-gcr && chmod +x ./docker-credential-gcr
export PATH=$PATH:.

echo "Setting the Auto-sidecar injection"
kubectl --overwrite=true label namespace default istio-injection=enabled

echo "Building Search service"
cd search
./mvnw compile jib:build
kubectl apply -f src/main/k8s/search.v1.yaml
cd ..

echo "Building UI service"
cd ui
./mvnw compile jib:build
kubectl apply -f src/main/k8s/ui.v1.yaml