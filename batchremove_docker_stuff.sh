for i in "${@:2}"
	do
		echo "removing:$i from $1s"
		docker "$1" rm "$i"
	done
#usage ./batchremove_docker_stuff.sh [container | image] id1 id2 id3 .....