#!/bin/sh
set -e
echo "Generating ejabberd.yml from template..."
#FOLDER="/opt/ejabberd/build/etc/ejabberd/ssl"
#FOLDER=${1:-.}        # Default to current folder if not specified
sed "s|\${DB_NAME}|${DB_NAME}|g;
     s|\${DB_USER}|${DB_USER}|g;
     s|\${DB_PASSWORD}|${DB_PASSWORD}|g;
     s|\${DB_HOST}|${DB_HOST}|g;
     s|\${DB_PORT}|${DB_PORT}|g;
     s|\${CERT_NUMBER}|${CERT_NUMBER}|g;
     s|\${EJABBERD_DOMAIN}|${EJABBERD_DOMAIN}|g" \
     /opt/ejabberd/build/etc/ejabberd/ejabberd.yml.template \
     > /opt/ejabberd/build/etc/ejabberd/ejabberd.yml
echo "Starting ejabberd..."
exec ejabberdctl foreground

