#!/bin/bash

action="$1"				#up/down

if [ -z "$action" ]; then
	echo "Usage: ./galera.sh [up/down]"
	exit 1
fi

if [ "$action" = "up" ]; then
	docker network create --subnet="192.168.128.0/17" galeranet
fi

case "$action" in
	up)
		action+=" -d"
		docker compose -p galera1 -f docker-compose-db1.yaml $action
		sleep 6
		docker compose -p galera2 -f docker-compose-db2.yaml $action
		docker compose -p galera3 -f docker-compose-db3.yaml $action
		;;
	down)
		for i in $(seq 3 -1 1); do
            if [ $i = 1 ]; then
                    sleep 6
            fi
			docker compose -p galera${i} down
		done
		;;
esac

if [[ "$action" = "down" && $? -eq 0 ]]; then
	docker network rm galeranet
fi
