#!/bin/bash

SCRIPT=$(basename $0)

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

function exit_if_installed(){
    which $1 > /dev/null 2>/dev/null
    [ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
    echo "installing.."

    TMPDIR=$(mktemp -d)
    trap 'rm -rf -- "$TMPDIR"' EXIT
    cd $TMPDIR
}
