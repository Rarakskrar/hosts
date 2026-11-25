#!/bin/bash

verifica_ip() {
    local nume="$1"
    local ip="$2"
    local dns_server="$3"

    ip_dns=$(nslookup "$nume" "$dns_server" 2>/dev/null | grep "^Address:" | grep -v "#" | awk '{print $2}')

    if [[ -n "$ip_dns" ]]; then
        if ! echo "$ip_dns" | grep -qx "$ip"; then
            echo "Bogus IP for $nume in /etc/hosts!"
        fi
    fi
}

cat /etc/hosts | while read -r ip nume rest || [[ -n "$ip" ]]; do
    if [[ -z "$ip" || "$ip" == \#* || -z "$nume" ]]; then
        continue
    fi

    verifica_ip "$nume" "$ip" "8.8.8.8"
done
