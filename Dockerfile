# Image Tag: registry.digital360.com.au/engineroom-7.2:$image_version

FROM httpd:alpine

RUN apk add --no-cache --update \
# Install tini - 'cause zombies - see: https://github.com/ochinchina/supervisord/issues/60
# (also pkill hack)
    tini

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/Options Indexes/Options /g' /usr/local/apache2/conf/httpd.conf && \
    rm -rf /var/cache/apk/*

# Install a golang port of supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord

COPY supervisord.conf /supervisord.conf
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]]