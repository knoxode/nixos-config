#!/usr/bin/env bash

status="$(cat /sys/class/power_supply/BAT0/status)"
level="$(cat /sys/class/power_supply/BAT0/capacity)"

if [[ ("$status" == "Discharging") || ("$status" == "Full") ]]; then
  if [[ "$level" -eq "0" ]]; then
    printf "\n"
  elif [[ ("$level" -ge "0") && ("$level" -le "25") ]]; then
    printf "\n"
  elif [[ ("$level" -ge "25") && ("$level" -le "50") ]]; then
    printf "\n"
  elif [[ ("$level" -ge "50") && ("$level" -le "75") ]]; then
    printf "\n"
  elif [[ ("$level" -ge "75") && ("$level" -le "100") ]]; then
    printf "\n"
  fi
fi


if [[ "$status" == "Charging" ]]; then
  printf "󰂄\n"
fi

if [[ "$status" == "Not charging" ]];then
  printf "󱐋\n"
fi


