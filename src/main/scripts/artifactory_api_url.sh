#!/bin/sh
# Used by other Artifactory Utilities to determine the 
# API URL of Artifactory REST services.
# The URL is printed out.
BASE_URL="$($(cd $(dirname $(readlink -f $0));pwd)/artifactory_base_url.sh $@)"
if [ $? == 0 ]; then
	echo "$BASE_URL/api"
else
	>&2 echo "Cannot resolve Artifactory API URL"
	exit 1
fi
