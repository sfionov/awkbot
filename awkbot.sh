#!/bin/sh

socat -v TCP6:irc.meganet.ru:7770,nodelay,nonblock SYSTEM:./awkbot.awk,pty,echo=0 >> awkbot.log 2>&1

