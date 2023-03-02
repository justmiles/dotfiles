#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed git-bump

set -e

curl -sf https://gobinaries.com/b4b4r07/git-bump | PREFIX=~/.local/bin sh
