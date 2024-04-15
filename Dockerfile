FROM nginx:stable-alpine3.17
LABEL maintainer "interxis@gmail.com"

# Install GitWeb and dependencies
RUN set -ex; \
    apk add --no-cache \
        fcgiwrap \
        fcgiwrap-openrc \
        git-gitweb \
        git-daemon \
        openrc \
        perl-cgi \
    ;

# Install fcgiwrap start script on Nginx's docker-entrypoint
ENV FCGIWRAP_BIN=50-start-fcgiwrap.sh \
    ENTRYPOINT_DIR=/docker-entrypoint.d
ENV FCGIWRAP_PATH=${ENTRYPOINT_DIR}/${FCGIWRAP_BIN}
COPY ${FCGIWRAP_BIN} ${FCGIWRAP_PATH}
RUN set -eux; chmod 755 "${FCGIWRAP_PATH}"

# Configure Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Configure GitWeb
COPY gitweb.conf /etc/gitweb.conf

# Configure Theme
COPY gitweb.css /usr/share/gitweb/theme/gitweb.css
