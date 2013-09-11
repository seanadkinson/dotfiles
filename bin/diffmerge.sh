#!/bin/sh
## A little script to make it easier to launch DiffMerge from the command line.
## Install this script into a folder in your path, such as /usr/bin or /usr/local/bin.
##
## Version 3.3.2.1139
## Copyright (C) 2003-2011 SourceGear LLC. All Rights Reserved.
##############################################################################

## The actual executable is hidden inside the .app bundle.

DIFFMERGE_EXE=/usr/local/bin/DiffMerge

## Launch DiffMerge using the given command line arguments.  Use --help for
## additional information or see the man page distributed along with this
## shell script.

exec ${DIFFMERGE_EXE} --nosplash "$@"



