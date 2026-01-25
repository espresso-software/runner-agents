#!/bin/bash
set -e

if [ -z "$GH_ACTIONS_URL" ]; then
  echo 1>&2 "error: missing GH_ACTIONS_URL environment variable"
  exit 1
fi

if [ -z "$TOKEN" ]; then
  echo 1>&2 "error: missing TOKEN environment variable"
  exit 1
fi

if [ -n "$WORK" ]; then
  mkdir -p "$WORK"
fi

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Github Actions Runner agent..."

    # If the agent has some running jobs, the configuration removal process will fail.
    # So, give it some time to finish the job.
    while true; do
      ./config.sh remove --token "$RUNNER_TOKEN" && break

      echo "Retrying in 30 seconds..."
      sleep 30
    done
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

source ./env.sh

print_header "1. Generating Agent Token..."

URI="https://api.github.com"
GH_ACTIONS_ORG="espresso-software"

API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
AUTH_HEADER="Authorization: Bearer ${TOKEN}"
CONTENT_LENGTH_HEADER="Content-Length: 0"

FULL_URL="${URI}/orgs/${GH_ACTIONS_ORG}/actions/runners/registration-token"

RUNNER_TOKEN="$(curl -XPOST -fsSL \
  -H "${CONTENT_LENGTH_HEADER}" \
  -H "${AUTH_HEADER}" \
  -H "${API_HEADER}" \
  "${FULL_URL}" \
| jq -r '.token')"

print_header "2. Configuring Github Actions Runner agent..."

./config.sh --unattended \
  --url "$GH_ACTIONS_URL" \
  --token "$RUNNER_TOKEN" \
  --work "${WORK:-_work}" \
  --labels "${GH_ACTIONS_LABELS}" \
  --replace \
  --disableupdate & wait $!

print_header "3. Configure environment for the agent..."
echo "http_proxy=${HTTP_PROXY}" >> /usr/mware/agent/.env
echo "https_proxy=${HTTPS_PROXY}" >> /usr/mware/agent/.env
echo "ftp_proxy=${FTP_PROXY}" >> /usr/mware/agent/.env
echo "no_proxy=${NO_PROXY}" >> /usr/mware/agent/.env

print_header "4. Running Github Actions Runner agent..."

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

chmod +x ./bin/Runner.Listener

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./bin/Runner.Listener run --startuptype service & wait $!

exit 0
