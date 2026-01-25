#!/bin/bash

set -e

INSTALL="false"
UNINSTALL="false"
HOSTS="ansible-k3s"

while [[ $# -gt 0 ]]; do
  case $1 in
    --install)
      INSTALL="true"
      shift
      ;;
    --uninstall)
      UNINSTALL="true"
      shift
      ;;
    --hosts)
      HOSTS="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# if install and uninstall are both true or both false, exit with error
if [ "$INSTALL" == "true" ] && [ "$UNINSTALL" == "true" ]; then
  echo "Error: Cannot specify both --install and --uninstall options."
  exit 1
fi
if [ "$INSTALL" == "false" ] && [ "$UNINSTALL" == "false" ]; then
  echo "Error: Must specify either --install or --uninstall option."
  exit 1
fi

PLAYBOOK=""
if [ "$INSTALL" == "true" ]; then
  PLAYBOOK="docker.yml"
fi
if [ "$UNINSTALL" == "true" ]; then
  PLAYBOOK="uninstall-docker.yml"
fi

ansible-playbook --vault-password-file ~/vault -i inventory/restricted.yml -l ${HOSTS} ${PLAYBOOK} -v