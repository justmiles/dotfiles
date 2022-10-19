#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed aws-sso-util

set -e

pipx install aws-sso-util