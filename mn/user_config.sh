#!/bin/bash

if [ -z "$1" ]; then
        echo "Usage: user_config.sh <username>";
        echo ""
        exit
fi

if [ `getent passwd $1` ]; then
  echo "User $1 already exists...Good"
else
  echo "Adding User $1..."
  /usr/sbin/useradd -m -s /bin/bash $1
  echo "Setting $1 password..."
  passwd $1
  /usr/sbin/usermod -a -G ssh-uzer $1
  mkdir -p /home/$1
  mkdir -p /home/$1/.ssh
  chmod 700 /home/$1/.ssh
  touch /home/$1/.ssh/authorized_keys
  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6TegcvdmTqUPj/QIAeDem3V6+PFXVb1dBS8ilQSCwZ sfanjoy@CharlestonTek.com" >> /home/$1/.ssh/authorized_keys
  chmod 600 /home/$1/.ssh/authorized_keys
  chown -R $1:$1 /home/$1
fi
echo "User $1 Configured"
