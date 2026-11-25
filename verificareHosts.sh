#!/bin/bash

cat /etc/hosts | while read -r ip nume rest; do
        if [[ -z "$ip" || "$ip" == \#* || -z "$nume" ]]; then
                continue
        fi

        ip_dns=$(nslookup "$nume" 8.8.8.8 2>/dev/null | grep "^Address:" | grep -v "#" | awk '{print $2}')

        if [[ -n "$ip_dns" ]]; then
                if ! echo "$ip_dns" | grep -qx "$ip"; then
                        echo "Bogus IP for $nume in /etc/hosts!"
                fi
        fi
done
