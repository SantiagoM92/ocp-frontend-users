#!/bin/sh
set -eu

if [ -z "${API_PROXY_TARGET:-}" ]; then
  echo "API_PROXY_TARGET environment variable must be set" >&2
  exit 1
fi

NGINX_LISTEN_PORT="${NGINX_LISTEN_PORT:-4173}"
export API_PROXY_TARGET
export NGINX_LISTEN_PORT

TMP_CONF_DIR="${TMP_CONF_DIR:-/tmp/nginx}"
mkdir -p "${TMP_CONF_DIR}"
mkdir -p "${TMP_CONF_DIR}/client_temp" "${TMP_CONF_DIR}/proxy_temp" \
  "${TMP_CONF_DIR}/fastcgi_temp" "${TMP_CONF_DIR}/uwsgi_temp" "${TMP_CONF_DIR}/scgi_temp"

TEMPLATE_SRC="${NGINX_TEMPLATE_PATH:-/etc/nginx/conf.d/default.conf.template}"
TEMPLATE_DEST="${TMP_CONF_DIR}/nginx.conf"

envsubst '${API_PROXY_TARGET} ${NGINX_LISTEN_PORT}' < "${TEMPLATE_SRC}" > "${TEMPLATE_DEST}"

exec nginx -g 'daemon off;' -c "${TEMPLATE_DEST}"
