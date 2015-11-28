#!/bin/bash

LOG=logfile.txt
while IFS='' read -r line || [[ -n "$line" ]]; do
  ./get_status.sh "$line"
done < "hostaddresses_66.txt"