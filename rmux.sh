#!/usr/bin/env sh

COPY_OVER=true
HOST=""

for param in $@
do
    case $param in
        --remote)   COPY_OVER=false ;;
        *)          HOST=$param ;;
    esac
done


if [ $COPY_OVER = true ]; then
    if [ -z "$HOST" ]; then
        echo "host is required";
    else
        echo "Connecting to ${HOST}"
        ssh_cmd=`/usr/bin/env which ssh`
        scp_cmd=`/usr/bin/env which scp`
        myself=$0
        bname=`basename $myself`
        ${scp_cmd} ${myself} ${HOST}:~/${bname}
        ${ssh_cmd} $HOST -t "~/${bname}" --remote
        echo "Bye!"
    fi
else
    tmux_cmd=`/usr/bin/env which tmux`
    if [ -z "$tmux_cmd" ]; then
        ${SHELL}
    else
        sessions=`${tmux_cmd} ls -F "#{session_id}" 2>/dev/null`
        if [ -z "${sessions}" ]; then
            ${tmux_cmd}
        else
            ${tmux_cmd} a
        fi
    fi
fi