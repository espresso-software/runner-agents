#!/bin/bash
set -e

fail_probe() {
	echo "[ERROR] Health check probe failed" >&2
	rm -f ${GH_HC_FILE}
	exit 1
}

# CHECK ENVIRONMENT VARIABLES

if [[ -z "$GH_ACTIONS_HC_TOKEN" ]]
then
	echo "[ERROR] Missing GH_ACTIONS_HC_TOKEN environment variable" >& 2
	fail_probe
fi

if [[ -z "$GH_ACTIONS_URL" ]]
then
	echo "[ERROR] Missing GH_ACTIONS_URL environment variable" >& 2
	fail_probe
fi

if [[ -z "$GH_HC_FILE" ]]
then
	echo "[ERROR] Missing GH_HC_FILE environment variable" >& 2
	fail_probe
fi

while true; do
	/usr/mware/agent/run.sh --check --url $GH_ACTIONS_URL --pat $GH_ACTIONS_HC_TOKEN || fail_probe
	touch ${GH_HC_FILE}
	sleep 30
done
