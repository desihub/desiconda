#!/bin/bash

usage () {
	echo "usage:  <user> <group> <uid> <gid>"
}

if [ "x${1}" = "x--help" ]; then
	usage
	exit 0
fi

user=$1
if [ "x${user}" = "x" ]; then
	usage
	exit 0
fi

group=$2
if [ "x${group}" = "x" ]; then
	usage
	exit 0
fi

uid=$3
if [ "x${uid}" = "x" ]; then
	usage
	exit 0
fi

gid=$4
if [ "x${gid}" = "x" ]; then
	usage
	exit 0
fi

groupadd -f -g ${gid} ${group}

mkdir -p /home/${user}/.conda/pkgs
mkdir -p /home/${user}/conda-bld

echo "export PATH=/conda/bin:\${PATH}" > /home/${user}/.bashrc

echo "channels:" > /home/${user}/.condarc
echo "  - file:///home/${user}/conda-bld" >> /home/${user}/.condarc
echo "  - tskisner" >> /home/${user}/.condarc
echo "  - astropy" >> /home/${user}/.condarc
echo "  - defaults" >> /home/${user}/.condarc

ln -s /usr/src/work /home/${user}/work
cp /setup.sh /home/${user}/

useradd -r -d /home/${user} -u ${uid} -g ${group} ${user}

chown -R ${user} /home/${user}
chgrp -R ${group} /home/${user}

su - ${user} -c '/bin/bash'
