#!/bin/bash

# Forțează detectarea monitoarelor
xrandr --auto

# Verifică dacă monitoarele sunt conectate
primary_monitor=$(xrandr | grep "DP-0 connected")
secondary_monitor=$(xrandr | grep "DP-2 connected")

# Dacă nu sunt detectate, încearcă să repornești serviciul de display manager
if [ -z "$primary_monitor" ] || [ -z "$secondary_monitor" ]; then
    echo "Monitorul nu a fost detectat, încerc să repornesc display managerul..."
    sudo systemctl restart display-manager
    sleep 5  # Așteaptă câteva secunde pentru a permite serviciului să repornească

    # Reaplică configurația
    primary_monitor=$(xrandr | grep "DP-0 connected")
    secondary_monitor=$(xrandr | grep "DP-2 connected")
fi

# Aplică configurația în funcție de monitoarele detectate
if [ "$primary_monitor" ] && [ "$secondary_monitor" ]; then
    xrandr --output DP-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --rate 240.00
    xrandr --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --rate 360.01
# Mută workspace-urile la monitoarele dorite
    i3-msg "workspace 1; move workspace to output DP-2"
    i3-msg "workspace 2; move workspace to output DP-0"
elif [ "$primary_monitor" ]; then
    xrandr --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --rate 240.00
    xrandr --output DP-2 --off
elif [ "$secondary_monitor" ]; then
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --rate 360.01
    xrandr --output DP-0 --off
else
    echo "Niciun monitor conectat!"
fi
