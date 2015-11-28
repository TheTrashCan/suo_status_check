#!/bin/bash

ip=$1
ADDR="`cat ./hostnames | grep $ip | awk -F ':' {'print $1'}`"

if ping -c 3 $ip >/dev/null
then
#  version=$(expect get-suo-version.exp $ip | tee -a $LOG | grep APP_VERSION | cut -d = -f 2 | tr -d "\r" | tr -d \')
  text=`expect get-suo-version.exp $ip`
  version=$(echo $text | grep VERSION | cut -d = -f 2 | tr -d "\r" | cut -d \' -f 2)
  ssherror=$(echo $text | grep "my remote host")
  nofile=$(echo $text | grep "version.rb: No such file or directory")

  if [ "$ssherror" != "" ]; then
    echo "$ADDR%$ip%ssh error"
  else
    if [ "$nofile" != "" ]; then
      echo "$ADDR%$ip%1.4.0"
    else
      verlen=$(echo ${#version})
      if [[ $verlen -lt 30 ]]; then
        echo "$ADDR%$ip%$version"
      else
        echo "$ADDR%$ip%version error"
      fi
    fi
  fi

  # автоматическое обновление
  # уберите комментарии с этих строк для автоматического обновления

#  if [ "$version" != "1.5.2" ]; then
#    cap local deploy < $ip
#    expect kill-unicorn.exp $ip
#    cap local deploy:restart < $ip
#  else
#    echo "		update not required"
#  fi

else
  echo "$ADDR%$ip%pingfalse"
fi
