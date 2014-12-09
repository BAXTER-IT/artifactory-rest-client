#!/bin/sh
# Used by other Artifactory Utilities to determine the 
# base URL of Artifactory REST services.
# The URL is printed out.

# This is the default artifactory account
AF_ACCOUNT="baxter"

# First check the parameters, this is the highest priority
while [[ $# > 1 ]]; do
	opt="$1"
	shift
	case $opt in
		-a|--account)
			AF_ACCOUNT="$1"
			shift
			;;
		-u|--url)
			echo "$1"
			exit 0
			;;
		*)
			# Something else
			;;
	esac
done

readUrlFromFile() {
	if [ -f $1 ]; then
		V="$(cat $1 | grep "^url=" | cut -d= -f2)"
		if [ "x" != "x$V" ]; then
			echo "$V"
			exit 0
		fi
	fi
}

# Check for artifactory file in home
readUrlFromFile $HOME/.artifactory/$AF_ACCOUNT.artifactory

# Check for artifactory file in default conf location
readUrlFromFile ${f.cfg.dir}/$AF_ACCOUNT.artifactory

if [ "x" == "x$AF_ACCOUNT" ]; then
	>&2 echo "Cannot resolve Artifactory base URL"
	exit 1
else
	>&2 echo "Will guess Artifactory URL"
	echo "https://$AF_ACCOUNT.artifactoryonline.com/$AF_ACCOUNT"
fi
