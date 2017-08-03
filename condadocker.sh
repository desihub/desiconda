#!/bin/bash

usage () {
	echo ""
	echo "Usage:"
	echo "  ${0} <docker image tag/hash> <source tree to mount>"
	echo ""
}

img="$1"
if [ "x${img}" = "x" ]; then
	usage
	exit 0
fi

tree="$2"
if [ "x${tree}" = "x" ]; then
	usage
	exit 0
fi

# get the user / group info of the top of the source tree

user=$(stat -c '%U' "${tree}")
uid=$(stat -c '%u' "${tree}")
group=$(stat -c '%G' "${tree}")
gid=$(stat -c '%g' "${tree}")

# run docker image, passing the user / group info to the
# entry point so that the matching user / group is created
# inside the container.

docker run -it \
-v "${tree}:/usr/src/work" \
"${img}" \
"${user}" "${group}" "${uid}" "${gid}"

