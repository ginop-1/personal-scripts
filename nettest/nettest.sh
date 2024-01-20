#!/bin/bash

script_dir="$(dirname "$0")"

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/functions.sh"

# get the list of all arguments passed to the script
ARGS=("$@")

# check_dependencies

# display help
if [[ " ${ARGS[*]} " == *"--help"* ]]; then
    echo -e "${Color_Off}Usage: nettest.sh [OPTION]..."
    echo -e "Test network connectivity"
    echo -e "\nOptions:"
    echo -e "  --help\t\t\tDisplay this help message"
    echo -e "  --public-ip\t\t\tDisplay public IP address"
    echo -e "  --speedtest\t\t\tPerform speedtest"
    echo -e "  --ping\t\t\tPerform ping and provide results"
    exit 0
fi

# execute ip -br -4 a | grep UP and then pipe output to awk, mantaining a 20 space padding for interface name
IFS=$(ip -br -4 a | grep UP | awk '{printf "%-2d - %-20s IP: %s\n", NR, $1, $3}')

if [[ -z "$IFS" ]]; then
    echo -e "${Red}No working interfaces found"
    exit 1
fi

echo -e "Available interfaces:\n${IFS}"

# get default gateway (first route aka default with lowest metric)
GW=$(ip route | head -n 1 | awk '{print $3}')

# get DNS server
DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -n 1)

# get default interface
MAIN_IF=$(ip route | head -n 1 | awk '{print $5}')

echo -e "Preferred interface: $MAIN_IF\nPreferred Gateway:   $GW\nDNS Server:          $DNS"

ping_gateway
ping_cloudflare_ip
ping_google_dns

# check if --public-ip argument is passed
if [[ " ${ARGS[*]} " == *"--public-ip"* ]]; then
    public_ip
fi

# check if --speedtest argument is passed
if [[ " ${ARGS[*]} " == *"--speedtest"* ]]; then
    echo -e "${Color_Off}Performing speedtest..."
    if [[ -z $(which speedtest-cli) ]]; then
        echo -e "${Red}speedtest-cli is not installed${Color_Off}"
        exit 20
    fi
    speedtest-cli --simple
fi

# check if --ping argument is passed
if [[ " ${ARGS[*]} " == *"--ping"* ]]; then
    echo -e "${Color_Off}Performing ping..."
    ping_average
fi

exit 0
