#!/bin/sh

/etc/init.d/aria2 stop
list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ ! $list ]; then
  echo "list IS NULL"
else
if [ -z "`grep "bt_tracker " /etc/config/aria2`" ]; then
    sed -i "/bt_tracker/a\ 	option bt_tracker '${list}'" /etc/config/aria2
    echo add......
else
    sed -i "s@bt_tracker .*@bt_tracker '$list'@g" /etc/config/aria2
    echo update......
fi
fi
/etc/init.d/aria2 start