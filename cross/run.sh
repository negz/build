#!/bin/bash -e

ARGS="$@"
if [ $# -eq 0 ]; then
    ARGS=/bin/bash
fi

BUILDER_USER=${BUILDER_USER:-upbound}
BUILDER_GROUP=${BUILDER_GROUP:-upbound}
BUILDER_UID=${BUILDER_UID:-1000}
BUILDER_GID=${BUILDER_GID:-1000}

groupadd -o -g $BUILDER_GID $BUILDER_GROUP 2> /dev/null
useradd -o -m -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER 2> /dev/null
echo "$BUILDER_USER    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
export HOME=/home/${BUILDER_USER}
echo "127.0.0.1 $(cat /etc/hostname)" >> /etc/hosts
[[ -S /var/run/docker.sock ]] && chmod 666 /var/run/docker.sock
chown -R $BUILDER_UID:$BUILDER_GID $HOME
exec chpst -u :$BUILDER_UID:$BUILDER_GID ${ARGS}
