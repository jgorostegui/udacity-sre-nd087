#!/bin/bash

NAMESPACE="udacity"
V1_DEPLOYMENT="canary-v1"
V2_DEPLOYMENT="canary-v2"

echo "Ensuring all canary components are applied/updated..."
kubectl apply -f starter/apps/canary/index_v1_html.yml -n $NAMESPACE
kubectl apply -f starter/apps/canary/index_v2_html.yml -n $NAMESPACE
kubectl apply -f starter/apps/canary/canary-v1.yml -n $NAMESPACE # Ensures v1 is as defined
kubectl apply -f starter/apps/canary/canary-v2.yml -n $NAMESPACE
kubectl apply -f starter/apps/canary/canary-svc.yml -n $NAMESPACE # Apply modified service

# Wait for deployments to stabilize before scaling
echo "Waiting for initial deployment rollouts..."
kubectl rollout status deployment/$V1_DEPLOYMENT -n $NAMESPACE --timeout=90s
kubectl rollout status deployment/$V2_DEPLOYMENT -n $NAMESPACE --timeout=90s

# Target 50% traffic: assuming canary-v1.yml has 3 replicas and canary-v2.yml has 1 replica initially.
# For a total of 4 pods, 50/50 means 2 for v1 and 2 for v2.
# If your initial replica counts differ, adjust these target numbers.
# Based on starter files: canary-v1=3, canary-v2=1. Total 4. 50/50 => v1=2, v2=2.

REPLICAS_V1=2 
REPLICAS_V2=2

echo "Scaling $V1_DEPLOYMENT to $REPLICAS_V1 replicas..."
kubectl scale deployment $V1_DEPLOYMENT --replicas=$REPLICAS_V1 -n $NAMESPACE

echo "Scaling $V2_DEPLOYMENT to $REPLICAS_V2 replicas..."
kubectl scale deployment $V2_DEPLOYMENT --replicas=$REPLICAS_V2 -n $NAMESPACE

echo "Waiting for $V1_DEPLOYMENT scaled rollout..."
kubectl rollout status deployment/$V1_DEPLOYMENT -n $NAMESPACE --timeout=120s

echo "Waiting for $V2_DEPLOYMENT scaled rollout..."
kubectl rollout status deployment/$V2_DEPLOYMENT -n $NAMESPACE --timeout=120s

echo "Canary deployment scaled. Both versions should be at 50%."