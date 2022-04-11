#! /bin/sh

app=vishalhassanandani
version=ci_platform_portal_build; export version;
buildid=ci_platform_portal_build_unix; export buildid;

CURRENT_USER=`whoami`; export CURRENT_USER

echo '$CURRENT_USER'

##########################################################################
# log command and execute
##########################################################################
logexe()
{
  echo '['`date +%y%m%d-%H%M%S`'][CMD]' "$@"
  "$@"
}

##########################################################################
# log message with the timestamp to stderr
##########################################################################
warn()
{
        echo '['`date +%y%m%d-%H%M%S`'][WARNING]' "$@" >&2
}

