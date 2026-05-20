#!/usr/bin/env bash
# Sets Claude Code / Vertex AI environment variables.
# Usage: source scripts/setup-claude-vertex-env.sh
# If GCP_PROJECT_ID is unset, you are prompted to enter it (interactive terminal).

#set -euo pipefail

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Source this script so exports apply in your current shell: source ${BASH_SOURCE[0]}" >&2
  exit 1
fi

if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
  if [[ -t 0 ]]; then
    read -r -p "Enter GCP project ID: " GCP_PROJECT_ID
    GCP_PROJECT_ID="${GCP_PROJECT_ID#"${GCP_PROJECT_ID%%[![:space:]]*}"}"
    GCP_PROJECT_ID="${GCP_PROJECT_ID%"${GCP_PROJECT_ID##*[![:space:]]}"}"
  elif command -v gcloud &>/dev/null; then
    GCP_PROJECT_ID="$(gcloud config get-value project 2>/dev/null || true)"
    if [[ -z "${GCP_PROJECT_ID}" || "${GCP_PROJECT_ID}" == "(unset)" ]]; then
      echo "Set GCP_PROJECT_ID, or run this script in a terminal to enter it interactively." >&2
      return 1
    fi
  else
    echo "Set GCP_PROJECT_ID, or run this script in a terminal to enter it interactively." >&2
    return 1
  fi
fi

if [[ -z "${GCP_PROJECT_ID}" || "${GCP_PROJECT_ID}" == "(unset)" ]]; then
  echo "GCP_PROJECT_ID cannot be empty." >&2
  return 1
fi

export GCP_PROJECT_ID
export GOOGLE_APPLICATION_CREDENTIALS=/credentials/adc.json
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=global
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export ANTHROPIC_VERTEX_PROJECT_ID="${GCP_PROJECT_ID}"

echo "Environment variables set:"
echo "export GCP_PROJECT_ID=${GCP_PROJECT_ID}"
echo "export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}"
echo "export CLAUDE_CODE_USE_VERTEX=${CLAUDE_CODE_USE_VERTEX}"
echo "export CLOUD_ML_REGION=${CLOUD_ML_REGION}"
echo "export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC}"
echo "export ANTHROPIC_VERTEX_PROJECT_ID=${ANTHROPIC_VERTEX_PROJECT_ID}"

kubectl create configmap ai-tools-env \
  --from-literal=GOOGLE_APPLICATION_CREDENTIALS=/credentials/adc.json \
  --from-literal=CLAUDE_CODE_USE_VERTEX=1 \
  --from-literal=ANTHROPIC_VERTEX_PROJECT_ID=${GCP_PROJECT_ID} \
  --from-literal=ANTHROPIC_VERTEX_REGION=${CLOUD_ML_REGION} \
  --from-literal=CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl label configmap ai-tools-env \
  controller.devfile.io/mount-to-devworkspace=true \
  controller.devfile.io/watch-configmap=true \
  --overwrite
