#!/bin/sh
set -eu

if [ -z "${API_PROXY_TARGET:-}" ]; then
  echo "API_PROXY_TARGET environment variable must be set" >&2
  exit 1
fi

NGINX_LISTEN_PORT="${NGINX_LISTEN_PORT:-4173}"
export API_PROXY_TARGET
export NGINX_LISTEN_PORT

envsubst '${API_PROXY_TARGET} ${NGINX_LISTEN_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
