#!/bin/sh
# Used by other Artifactory Utilities to determine the 
# credential for Artifactory REST services.
# The credential is printed out in form user:password.

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
		-c|--credential)
			# Found the parameter, print it and quit
			echo "$1"
			exit 0
			;;
		*)
			# Something else
			;;
	esac
done

# Now check the environment variable, it has the second highest priority
if [ "x" != "x$AFCREDENTIAL" ]; then
	echo "$AFCREDENTIAL"
	exit 0
fi

readCredentialFromFile() {
	if [ -f $1 ]; then
		V="$(cat $1 | grep "^credential=" | cut -d= -f2)"
		if [ "x" != "x$V" ]; then
			echo "$V"
			exit 0
		fi
	fi
}

# Check for artifactory file in home
readCredentialFromFile $HOME/.artifactory/$AF_ACCOUNT.artifactory

# Check for artifactory file in default conf location
readCredentialFromFile ${f.cfg.dir}/$AF_ACCOUNT.artifactory

>&2 echo "Cannot resolve Artifactory credential" 
exit 1
