#!/bin/bash
set -e

if [[ -z "$GH_HC_FILE" ]]
then
    echo "[ERROR] Missing GH_HC_FILE environment variable" >& 2
    exit 1
fi

if [[ -f "$GH_HC_FILE" ]]
then
    exit 0
fi

echo "[ERROR] Health check probe failed" >&2
exit 1