#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Configuration
NAMESPACE="udacity"
CANARY_SERVICE_NAME="canary-svc"
CURL_OUTPUT_FILE="canary.txt"
PODS_OUTPUT_FILE="canary2.txt"
DEBUG_POD_NAME="canary-debug-curl"
CURL_IMAGE="curlimages/curl:latest" # A small image with curl

# --- Helper Function ---
get_canary_service_ip() {
  local ip
  ip=$(kubectl get service "$CANARY_SERVICE_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
  if [[ -z "$ip" ]]; then
    echo "Error: Could not retrieve IP for service '$CANARY_SERVICE_NAME' in namespace '$NAMESPACE'." >&2
    exit 1
  fi
  echo "$ip"
}

# --- Main Logic ---

if ! command -v kubectl &> /dev/null; then
  echo "Error: kubectl command not found. Please install it and ensure it's in your PATH." >&2
  exit 1
fi

echo "--- Generating Canary Deployment Results ---"

CANARY_SVC_IP=$(get_canary_service_ip)
echo "Canary Service IP: $CANARY_SVC_IP"
echo "Curling the service 10 times. Output will be saved to '$CURL_OUTPUT_FILE'..."

# Attempt to delete the pod if it exists from a previous run
kubectl delete pod "$DEBUG_POD_NAME" -n "$NAMESPACE" --ignore-not-found=true --nowait &>/dev/null || true
# Brief pause if pod was deleted
if [[ $? -eq 0 ]]; then sleep 2; fi


# Define the command to be run inside the pod.
# $CANARY_SVC_IP is expanded by the local shell.
# \$i and \$(seq 1 10) are escaped for the pod's shell.
POD_COMMAND_STRING="/bin/sh -c 'apk add --no-cache curl >/dev/null && \
echo \"Starting curl attempts...\"; \
for i in \$(seq 1 10); do \
  echo \"--------------------------\"; \
  echo \"Request: \$i\"; \
  curl -s --connect-timeout 5 http://${CANARY_SVC_IP}; \
  printf \"\n\"; \
done; \
echo \"Curl attempts finished.\";'"

# Run the temporary pod, re-enabling attach for --rm
# The output of 'kubectl run' (which includes the pod's stdout/stderr when attached) is redirected.
echo "Running temporary debug pod '$DEBUG_POD_NAME' to curl service..."
if kubectl run "$DEBUG_POD_NAME" \
  --image="$CURL_IMAGE" \
  --restart=Never \
  --rm \
  -i \
  --tty=false `# Avoid TTY allocation for non-interactive script` \
  -n "$NAMESPACE" \
  --overrides='{ "spec": { "terminationGracePeriodSeconds": 5 } }' \
  --command -- sh -c "eval $POD_COMMAND_STRING" > "$CURL_OUTPUT_FILE" 2>&1; then # Pass command string to sh -c for eval
  
  echo "Curl results saved to '$CURL_OUTPUT_FILE'."
else
  # If kubectl run fails, the output in $CURL_OUTPUT_FILE might contain the error from kubectl client
  echo "Error: kubectl run command execution might have failed for '$DEBUG_POD_NAME'." >&2
  echo "Check '$CURL_OUTPUT_FILE' for errors from kubectl client."
  # Since --rm is used, the pod might be gone, making log retrieval hard for client-side kubectl errors.
  # If the pod itself failed (command inside failed), --rm should still clean it up after it exits.
  exit 1
fi

# Check if the output file was created and contains expected content (basic check)
if [[ ! -s "$CURL_OUTPUT_FILE" ]] || ! grep -q "Curl attempts finished." "$CURL_OUTPUT_FILE"; then
  echo "Error: '$CURL_OUTPUT_FILE' is empty or incomplete. Debug pod command might have failed." >&2
  echo "Contents of $CURL_OUTPUT_FILE:"
  cat "$CURL_OUTPUT_FILE"
  exit 1
else
  echo "Ensure '$CURL_OUTPUT_FILE' shows mixed results from both canary versions."
fi

# 2. Get all pods
echo "Getting all pods in all namespaces. Output will be saved to '$PODS_OUTPUT_FILE'..."
if ! kubectl get pods --all-namespaces > "$PODS_OUTPUT_FILE"; then
  echo "Error: Failed to get pod list." >&2
  exit 1
fi
echo "Pod list saved to '$PODS_OUTPUT_FILE'."

echo "--- Canary result generation complete. ---"
echo "Please verify '$CURL_OUTPUT_FILE' and '$PODS_OUTPUT_FILE'."