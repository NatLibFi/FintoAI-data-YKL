#!/bin/bash

# Transfers data and projects.d directories to an OpenShift volume that is attached
# to a pod which is running Annif. The instance {api-annif-org,ai-finto-fi, etc.}
# which to transfer is given as the first argument.
# You need to be logged in to the cluster with the oc cli tool.

set -e

if [ $# -ne 1 ]
  then
    echo "Not enough arguments"
    exit 1
fi

# echo Syncing to instance $1
pod=$(oc get pods -l app.kubernetes.io/instance=$1,app.kubernetes.io/name=annif -o name)
pod=${pod#pod/}

if [ -z "${pod}" ]
  then
    echo "No target pod found"
    exit 1
fi
# echo Target pod is $pod

rsync --rsh='oc rsh' -avrL --exclude="*train*" --exclude="*zip" data projects.d $pod:/annif-projects/
