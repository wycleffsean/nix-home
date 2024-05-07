# Docker Machine
function setDockerEnv() {
  docker_machine_default=dinghy
  docker_machine_status=$(docker-machine status $docker_machine_default)
  if [[ "$docker_machine_status" == "Running" ]]
  then
    eval "$(docker-machine env $docker_machine_default)"
  fi
}
#setDockerEnv

function docker-volume-report() {
  for info in $(docker volume ls | awk '{ print $2 }'); do
    for path in $(docker inspect $info |  jq ".[].Mountpoint"); do
      for report in $(dinghy ssh  "sudo du -sh $path"); do
        echo $report
      done
    done
  done
}

function dockercleancontainers() {
  if [[ -n "${1}" ]]; then
    docker container rm -f $(docker container ls -aq -f name="${1}") &> /dev/null
  else
    # find exited containers that are not labeled "data" and remove them
    docker rm $(
      comm -13 \
        <(docker container ls -aq -f status=exited --no-trunc -f label=data | sort) \
        <(docker container ls -aq -f status=exited --no-trunc | sort)
    ) &> /dev/null
  fi
}

function dockercleanimages() {
  if [[ -n "${1}" ]]; then
    docker images | grep "${1}" | awk '{print $3}' | xargs docker rmi
  else
    docker rmi $(docker images -f dangling=true -q)
  fi
}

function dockerclean() {
  dockercleancontainers; dockercleanimages; dockerrmdanglingvolumes
}

function dockerrmdanglingimages() {
  docker rmi $(docker images -f dangling=true -q)
}

function dockerrmdanglingvolumes() {
  docker volume rm $(docker volume ls -qf dangling=true)
}

function dockerrmstoppedcontainers() {
  docker rm $(docker ps -q -f status=exited)
}

