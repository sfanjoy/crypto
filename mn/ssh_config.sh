#!/bin/bash
if [ `getent group ssh-uzer` ]; then
	  echo "Group ssh-uzer already exists. Good..."
  else
	    /usr/sbin/groupadd ssh-uzer
fi
rm -f /tmp/sshdA.tmp
rm -f /tmp/sshdB.tmp
#
# Remove the Attributes from the current file
#
grep -v "AllowGroups" /etc/ssh/sshd_config > /tmp/sshdA.tmp
grep -v "PermitRootLogin" /tmp/sshdA.tmp > /tmp/sshdB.tmp
grep -v "PubkeyAuthentication" /tmp/sshdB.tmp > /tmp/sshdA.tmp
grep -v "PasswordAuthentication" /tmp/sshdA.tmp > /tmp/sshdB.tmp
grep -v "ChallengeResponseAuthentication" /tmp/sshdB.tmp > /tmp/sshdA.tmp
grep -v "GSSAPIAuthentication" /tmp/sshdA.tmp > /tmp/sshdB.tmp
grep -v "UseDNS" /tmp/sshdB.tmp > /tmp/sshdA.tmp
#
# Put desired Attributes back at bottom of file
#
echo "AllowGroups ssh-uzer" >> /tmp/sshdA.tmp
echo "PubkeyAuthentication yes" >> /tmp/sshdA.tmp
echo "PermitRootLogin no" >> /tmp/sshdA.tmp
echo "PasswordAuthentication no" >> /tmp/sshdA.tmp
echo "ChallengeResponseAuthentication no" >> /tmp/sshdA.tmp
echo "GSSAPIAuthentication no" >> /tmp/sshdA.tmp
echo "UseDNS no" >> /tmp/sshdA.tmp

TDAY=`date "+%Y%m%d-%s"`
mv -f /etc/ssh/sshd_config /etc/ssh/sshd_config.$TDAY
mv -f /tmp/sshdA.tmp /etc/ssh/sshd_config
#
# restart ssh daemon
systemctl restart sshd
systemctl status sshd --no-pager
