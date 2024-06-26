ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:10.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Copy root filesystem
COPY rootfs /

RUN ["chmod", "+x", "/etc/openvpn/up-transmission.sh"]

# Setup base
RUN apk add --no-cache \
    coreutils=8.32-r2 \
    nginx=1.20.1-r3 \
    transmission-daemon=3.00-r3 \
    openvpn=2.5.2-r0
# Small hack needed for ingress support
#
# Transmission always uses "transmission" as a subdirectory in the URL, so the web interface can for instance be found at:
#
#   http://<server>/transmission/web/
#
# The same goes for the RPC API, which is exposed under /transmission/rpc. When using ingress, this is not the case however
# and "transmission" directory is not part of the URL. So transmission is basically served under the root (/), e.g.:
#
#   http://10.0.10.110:8123/api/hassio_ingress/rQEi5X4zJFTmZ82ghplDjsx2AoK3r2lqx0zZHHjZ69Q/
#
# As the web UI uses a relative path when resolving the RPC endpoint, it basically becomes:
#
#   http://10.0.10.110:8123/api/hassio_ingress/rQEi5X4zJFTmZ82ghplDjsx2AoK3r2lqx0zZHHjZ69Q/../rpc
#
# which obviously is:
#
#   http://10.0.10.110:8123/api/hassio_ingress
#
# This will not work. The sed statement below changes the way the RPC endpoint is determined by keeping the regular endpoint
# when accessing transmission as usual, but stripping the relative part when using ingress.
RUN sed -i 's|'"'"'\.\./rpc'"'"'|window.location.pathname.endsWith("/web/") ? "../rpc" : "rpc"|' /usr/share/transmission/web/javascript/remote.js

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Transmission" \
    io.hass.description="Torrent client for Home Assistant with OpenVPN support" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    maintainer="haberda" \
    org.label-schema.description="Torrent client for Home Assistant with OpenVPN support" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.name="Transmission" \
    org.label-schema.schema-version=${BUILD_VERSION} \
    org.label-schema.url="https://github.com/haberda/hassio-addon-transmission" \
    org.label-schema.usage="https://github.com/haberda/hassio-addon-transmission/tree/master/README.md" \
    org.label-schema.vcs-ref="${BUILD_REF}" \
    org.label-schema.vcs-url="https://github.com/haberda/" \
    org.label-schema.vendor="No Vendor"
