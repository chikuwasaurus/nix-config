FROM alpine:3.24.1

# User settings inside the container
# These are intended to match the UID/GID on the macOS host
ARG USERNAME=kyohei
ARG UID=501
ARG GID=20

RUN apk update && apk add --no-cache \
    zsh \
    sudo \
    git \
    ca-certificates \
    nix

# Create or reuse the user's primary group
# If the requested GID already exists, reuse the existing group
# This is useful for macOS, where GID 20 is commonly used by the staff group
RUN GROUPNAME="$(getent group "$GID" | cut -d: -f1)" \
    && if [ -z "$GROUPNAME" ]; then \
         GROUPNAME="$USERNAME"; \
         addgroup -g "$GID" "$GROUPNAME"; \
       fi \
    && adduser -D -u "$UID" -G "$GROUPNAME" -s /bin/zsh "$USERNAME" \
    && addgroup "$USERNAME" wheel \
    && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
    && chmod 0440 /etc/sudoers.d/wheel

RUN mkdir -p /etc/nix /nix/store /nix/var/nix \
    && chown -R ${UID}:${GID} /nix \
    && printf '%s\n' \
      'experimental-features = nix-command flakes' \
      'store = local' \
      > /etc/nix/nix.conf
