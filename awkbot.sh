#!/bin/sh

socat -b 100 -v TCP6:irc.meganet.ru:7770 SYSTEM:./awkbot.awk,pty,echo=0 >> awkbot.log 2>&1

