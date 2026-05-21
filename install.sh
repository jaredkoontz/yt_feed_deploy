#!/usr/bin/env bash
set -euo pipefail

APP_NAME="yt-feed"
REPO="jaredkoontz/yt_feed_deploy"
VERSION="${1:-}"

if [[ -z "$VERSION" ]]; then
  echo "Usage: ./install.sh <version>"
  exit 1
fi

BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"

echo "Installing ${APP_NAME} ${VERSION}"

mkdir -p "${APP_NAME}"
cd "${APP_NAME}"

echo "Downloading compose file"
curl -fsSLO "${BASE_URL}/docker-compose.yml"

if [[ ! -f .env ]]; then
  echo "Downloading env template"
  curl -fsSLO "${BASE_URL}/default.env.example"
  cp default.env.example .env
  echo "Edit .env before continuing"
  exit 0
fi

echo "Starting..."
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d

echo "${APP_NAME} ${VERSION} deployed"
