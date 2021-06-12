#!/usr/bin/with-contenv bashio
# ==============================================================================
declare CONFIG

CONFIG=$(</data/transmission/settings.json)

CONFIG=$(bashio::jq "${CONFIG}" ".\"bind-address-ipv4\"=\"0.0.0.0\"")

echo "${CONFIG}" > /data/transmission/settings.json

exec /usr/bin/transmission-daemon --foreground --config-dir /data/transmission

export localNet="192.168.0.0/16"

eval $(/sbin/ip route list match 0.0.0.0 | awk '{if($5!="tun0"){print "GW="$3"\nINT="$5; exit}}')

/sbin/ip route del "$localNet"

/sbin/ip route add "${localNet}" via "${GW}" dev "${INT}"
