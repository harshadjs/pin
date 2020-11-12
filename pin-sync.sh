#!/bin/bash

REPO=$(dirname $BASH_SOURCE[0])
CFG=~/.pin

. $CFG

## This file will be run as is inside the commands directory.
## Edit this file to add your own sync method.

# echo "No sync method defined. Please edit $REPO/pin-sync.sh to add your own sync method."

## For example, to backup to a git repo, uncomment the following lines:
git add .
git commit -m "Automated commit message"
git push

## To backup to a GCS bucket uncomment the following line and replace GCS url with your GCS url:
## gsutil $CMDS_DIR gs://mybucket/cmds
