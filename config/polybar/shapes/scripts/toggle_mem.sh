#!/bin/bash
fmt=$(cat /tmp/polybar_mem_fmt 2>/dev/null || echo "gb")
if [[ "$fmt" == "gb" ]]; then
    echo "mib" > /tmp/polybar_mem_fmt
    polybar-msg action mem_gb hide 2>/dev/null
    polybar-msg action mem_mib show 2>/dev/null
else
    echo "gb" > /tmp/polybar_mem_fmt
    polybar-msg action mem_mib hide 2>/dev/null
    polybar-msg action mem_gb show 2>/dev/null
fi
