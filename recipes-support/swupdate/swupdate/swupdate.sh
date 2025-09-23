#!/bin/sh

# Override these variables in sourced script(s) located
# in /usr/lib/swupdate/conf.d or /etc/swupdate/conf.d
SWUPDATE_ARGS="-v ${SWUPDATE_EXTRA_ARGS}"
SWUPDATE_WEBSERVER_ARGS=""
SWUPDATE_SURICATTA_ARGS=""

# source all files from /etc/swupdate/conf.d and /usr/lib/swupdate/conf.d/
# A file found in /etc replaces the same file in /usr
for f in `(test -d @LIBDIR@/swupdate/conf.d/ && ls -1 @LIBDIR@/swupdate/conf.d/; test -d /etc/swupdate/conf.d && ls -1 /etc/swupdate/conf.d) | sort -u`; do
  if [ -f /etc/swupdate/conf.d/$f ]; then
    . /etc/swupdate/conf.d/$f
  else
    . @LIBDIR@/swupdate/conf.d/$f
  fi
done

# clean update_available flag, disabling rollback mechanism
if [ "$(fw_printenv -n upgrade_available)" == "1" ]; then
	echo "Upgrade successfully done, clean upgrade_available flag"
	fw_setenv upgrade_available 0
fi

#  handle variable escaping in a simmple way. Use exec to forward open filedescriptors from systemd open.
if [ "$SWUPDATE_WEBSERVER_ARGS" != "" -a  "$SWUPDATE_SURICATTA_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -w "$SWUPDATE_WEBSERVER_ARGS" -u "$SWUPDATE_SURICATTA_ARGS"
elif [ "$SWUPDATE_WEBSERVER_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -w "$SWUPDATE_WEBSERVER_ARGS"
elif [ "$SWUPDATE_SURICATTA_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -u "$SWUPDATE_SURICATTA_ARGS"
else
  exec /usr/bin/swupdate $SWUPDATE_ARGS
fi
