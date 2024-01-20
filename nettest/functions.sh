function check_dependencies() {
    if [[ -z $(which ip) ]]; then
        echo -e "${Red}iproute2 is not installed${Color_Off}"
        exit 1
    fi

    if [[ -z $(which awk) ]]; then
        echo -e "${Red}awk is not installed${Color_Off}"
        exit 2
    fi

    if [[ -z $(which ping) ]]; then
        echo -e "${Red}ping is not installed${Color_Off}"
        exit 3
    fi

    if [[ -z $(which wget) ]]; then
        echo -e "${Red}wget is not installed${Color_Off}"
        exit 4
    fi
}

function ping_gateway() {
    ping -W 5 -c 1 "$GW" > /dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${Green}Gateway is reachable"
    else
        echo -e "${Red}Gateway is not reachable"
        exit 10
    fi
}

function ping_cloudflare_ip() {
    ping -W 5 -c 1 "1.1.1.1" > /dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${Green}Internet is reachable"
    else
        echo -e "${Red}Internet is not reachable"
        exit 11
    fi
}

function ping_google_dns() {
    ping -W 5 -w 5 -c 1 "dns.google.com" > /dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${Green}DNS is working"
    else
        echo -e "${Red}DNS is not working"
        exit 12
    fi
}

function public_ip() {
    PUB_IP=$(wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1)
    echo -e -n "${Color_Off}"
    printf "%-24s %s" "Public IP:" "${PUB_IP}"; echo # remove highlighted percentage sign for zsh
}

function ping_average() {
    PING_AVG=$(ping -W 5 -c 5 "1.1.1.1" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    echo -e -n "${Color_Off}"
    printf "%-21s %s" "Ping average:" "${PING_AVG} ms"; echo # remove highlighted percentage sign for zsh
}