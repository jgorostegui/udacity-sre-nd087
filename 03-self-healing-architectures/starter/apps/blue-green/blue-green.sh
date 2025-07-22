#!/bin/bash

# This script deploys the "green" version of the application.

NAMESPACE="udacity"
GREEN_DEPLOYMENT_FILE="starter/apps/blue-green/green.yml"
GREEN_CONFIG_FILE="starter/apps/blue-green/index_green_html.yml"

echo "Applying Green ConfigMap from $GREEN_CONFIG_FILE..."
kubectl apply -f $GREEN_CONFIG_FILE -n $NAMESPACE

echo "Applying Green Deployment from $GREEN_DEPLOYMENT_FILE..."
kubectl apply -f $GREEN_DEPLOYMENT_FILE -n $NAMESPACE

echo "Waiting for Green deployment rollout to complete..."
# This command fulfills requirement #3 from the instructions.
kubectl rollout status -f $GREEN_DEPLOYMENT_FILE -n $NAMESPACE --timeout=120s

if [ $? -eq 0 ]; then
  echo "Green deployment completed successfully!"
else
  echo "Green deployment failed to complete." >&2
  exit 1
fi

echo "Next: Update Terraform to create the green-svc and weighted DNS records."