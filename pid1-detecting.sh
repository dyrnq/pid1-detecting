#!/bin/bash

comm="$(cat /proc/1/comm 2> /dev/null)"

if [[ "$comm" =~ systemd ]]; then
    init="systemd"
elif [[ "$comm" =~ epoch ]]; then
    init="Epoch"
elif [[ "$comm" =~ runit ]]; then
    init="runit"    
fi

if [ -z "$init" ]; then
    if [[ $(/sbin/init --version 2> /dev/null) =~ upstart ]]; then
        init="Upstart"
    elif command -v "launchctl" > /dev/null 2>&1; then
        init="launchd";
    elif [ -f "/etc/inittab" ]; then
        init="SysVinit";
    elif [ -f "/etc/ttys" ]; then
        init="init (BSD)";
    fi
fi

if ls /run/*openrc* > /dev/null 2>&1; then
    init="OpenRC";
fi
echo "$init"