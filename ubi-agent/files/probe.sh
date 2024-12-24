#!/bin/bash
set -e

# CHECK ENVIRONMENT VARIABLES

if [[ -z "$GH_ACTIONS_HC_TOKEN" ]]
then
	echo "[ERROR] Missing GH_ACTIONS_HC_TOKEN environment variable" >& 2
	exit 1
fi

if [[ -z "$GH_ACTIONS_URL" ]]
then
	echo "[ERROR] Missing GH_ACTIONS_URL environment variable" >& 2
	exit 1
fi

/usr/mware/agent/run.sh --check --url $GH_ACTIONS_URL --pat $GH_ACTIONS_HC_TOKEN || exit 1