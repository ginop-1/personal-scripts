recent_file="$HOME/IT/scripts/recent.txt"

echo "Reset current IP config? (y/n): "
read choices
if [ $choices = "y" ]; then
    doas dhclient -r
fi

# recent file has this format:
# IP: ip/subnet
# GW: gateway
# interface: interface
echo "Use recent IP? (y/n): "
read choices
if [ $choices = "y" ]; then
    # get IP and gateway from recent file
    ip=$(grep "IP:" $recent_file | cut -d' ' -f2)
    gateway=$(grep "GW:" $recent_file | cut -d' ' -f2)
    interface=$(grep "interface:" $recent_file | cut -d' ' -f2)
    echo "IP: $ip, GW: $gateway, interface: $interface"
    # set static IP
    doas ip addr add $ip broadcast + dev $interface
    # set gateway
    doas ip route add default via $gateway dev $interface
    exit 0
fi

# get IP address from user
echo "Enter IP address (ip/subnet): "
read ip
echo "IP: $ip" >> $recent_file
# get gateway from user
echo "Enter gateway (ip): "
read gateway
echo "GW: $gateway" >> $recent_file

# get a list of all interfaces
interfaces=$(ip link show | grep -oE '[0-9]+: .+:')
# remove : from the end of each interface
interfaces=${interfaces//:/}

echo -e "Interfaces: \n$interfaces"
# get interface from user
echo "Enter interface: "
read interface

# check if interface is valid
if [[ ! $interfaces =~ (^|[[:space:]])$interface($|[[:space:]]) ]]; then
    echo "Invalid interface"
    exit 1
fi

# set static IP
doas ip addr add $ip broadcast + dev $interface
# set gateway
doas ip route add default via $gateway dev $interface