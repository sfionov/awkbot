#!/bin/sh

PROTO=TCP6
SERVER=irc.meganet.ru
PORT=7770

SCRIPTPATH="./awkbot.awk"
SOCKOPTS="nodelay,nonblock"
SYSTEMOPTS="pty,echo=0"

LOGFILE=awkbot.log

{
    echo
    echo IRC Bot started at $(date)
    socat -v ${PROTO}:${SERVER}:${PORT}${SOCKOPTS:+,}${SOCKOPTS} SYSTEM:${SCRIPTPATH}${SYSTEMOPTS:+,}${SYSTEMOPTS}
} >> ${LOGFILE} 2>&1

