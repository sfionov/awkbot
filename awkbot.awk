#!/usr/bin/awk -f

############################################################
# AWK Bot
# (C) 2011 sig_wall/#overclockers.ru@RusNet


function init() {
    channel_name="#overclockers.ru"
    my_nick="overbot"
    real_name="Overclockers.ru bot"
    nickserv_password=""
}

function get_nick(x) {
    gsub(/!.*/,"",x)
    gsub(/^:/,"",x)
    return x
}

function privmsg(nick, message) {
    print "PRIVMSG " nick " :" message
}

function notice(nick, message) {
    print "NOTICE " nick " :" message
}

function ctcpquery(nick, type, message) {
    return privmsg(nick, "\001" type " " message "\001")
}

function ctcpreply(nick, type, message) {
    return notice(nick, "\001" type " " message "\001")
}

function mode(user,modes,params) {
    print "MODE " user " " modes " :" params
}

function nickserv_identify(pass) {
    print "NICKSERV :IDENTIFY " pass
}

function change_nick(new_nick) {
    print "NICK " new_nick
}

function user(ident,modes,real_name) {
    print "USER " ident " " modes " * :" real_name
}

function join_channel(channel_name) {
    print "JOIN :" channel_name
}

############################################################
# Input processing

BEGIN {
    init()
    change_nick(my_nick)
    user(my_nick,"+",real_name)
}

# When connected, join channel
$2=="001" {
    join_channel(channel_name)
}

# Play pingpong
/^PING/ {
    gsub("PING", "PONG")
    print
}

# CTCP PING user on join
$2=="JOIN" {
    if ((get_nick($1)!=my_nick) && ($1!~/zarkon/))
	ctcpquery(get_nick($1), "PING", systime())
}

# Ask to CTCP PING
($2=="PRIVMSG") && ($4~/^:\001PING/) {
    gsub("\001","",$5);
    ctcpreply(get_nick($1), "PING", $5)
}

# Ask to CTCP VERSION
($2=="PRIVMSG") && ($4~/^:\001VERSION/) {
    ctcpreply(get_nick($1), "VERSION", "AWK Bot rev. 4")
}

# Process user CTCP PING reply
($2=="NOTICE") && ($4~/^:\001/) {
# Voice user
    mode(channel_name, "+v", get_nick($1))
}

# NickServ IDENTIFY if asked
($1~/^:NickServ/) && /IDENTIFY/ {
    nickserv_identify(nickserv_password)
}

# Rejoin on kick
($2=="KICK") && ($4==my_nick) {
    system("sleep 10")
    join_channel(channel_name)
}
