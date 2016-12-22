#!/bin/bash

socat TCP-LISTEN:8088,reuseaddr,fork TCP:$(getent hosts application | awk '{ print $1 }'):80 | sh