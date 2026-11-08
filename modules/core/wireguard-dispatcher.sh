#!/usr/bin/env bash
case "$2" in
  up|connectivity-change|dhcp4-change|dhcp6-change|reapply)
    case "$1" in
      lo|wg0) exit 0 ;;
    esac
    mkdir -p /run/wireguard-endpoint
    if [ "$2" = up ]; then
      touch /run/wireguard-endpoint/reset-hold
    fi
    systemctl start --no-block wg-endpoint-select.service
    ;;
esac
exit 0
