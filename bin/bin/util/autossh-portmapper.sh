#!/usr/bin/env bash

# Intended to be called by systemd, to simplify mapping ports to server
# for example,
# systemd enable autossh-mapper@8080:localhost:80-user@example.org

host="${1#*-}"
portmapper="${1%-*}"

echo autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" -N -R "$portmapper" "$host"
autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" -N -R "$portmapper" "$host"
