#!/usr/bin/with-contenv bashio
# ==============================================================================
declare CONFIG

CONFIG=$(</data/transmission/settings.json)

CONFIG=$(bashio::jq "${CONFIG}" ".\"bind-address-ipv4\"=\"0.0.0.0\"")

echo "${CONFIG}" > /data/transmission/settings.json

export localNet="192.168.1.0/24"

eval $(/sbin/ip route list match 0.0.0.0 | awk '{if($5!="tun0"){print "GW="$3"\nINT="$5; exit}}')

echo "adding route to local network ${localNet} via ${GW} dev ${INT}"

/sbin/ip route del "$localNet"

/sbin/ip route add "${localNet}" via "${GW}" dev "${INT}"

exec /usr/bin/transmission-daemon --foreground --config-dir /data/transmission
