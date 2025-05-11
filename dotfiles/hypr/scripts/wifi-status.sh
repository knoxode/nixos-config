#!/usr/bin/env bash

primary_conn_type=$(nmcli -t -f TYPE connection show --active | head -n 1)

if [[ "$primary_conn_type" == "802-11-wireless" ]]; then
  strength="$(nmcli -f IN-USE,SIGNAL device wifi | grep '*' | awk '{print $2}')"
  if [[ "$?" == "0" ]]; then
    if [[ "$strength" -eq 0 ]]; then
      printf "󰤯 \n"
    elif [[ "$strength" -le 25 ]]; then
      printf "󰤟 \n"  
    elif [[ "$strength" -le 50 ]]; then
      printf "󰤢 \n"
    elif [[ "$strength" -le 75 ]]; then
      printf "󰤥 \n"
    else
      printf "󰤨 \n"
    fi
  else
    printf "󰈀 \n"
  fi
fi
