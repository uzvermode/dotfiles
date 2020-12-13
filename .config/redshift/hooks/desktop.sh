#!/bin/bash

set -eu

exec >> ~/.redshift-hooks.log 2>&1



if [ "$1" = period-changed ]; then
    echo $(date +"%y-%m-%d %H:%M:%S") $@
	case $3 in
		night)
			echo "Night"
			;;
		transition)
			echo "Transition"
            ;;
		daytime)
			echo "Daytime"
			;;
	esac
fi
