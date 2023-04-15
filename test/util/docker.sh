
start_container() {
  name=$1

  docker run \
    --name=$name \
    -d \
    -e "PATH=$(path)" \
    --privileged \
    mubox/portal
}

stop_container() {
  docker stop $1
  docker rm $1
}

path() {
  paths=(
    "/opt/gomicro/sbin"
    "/opt/gomicro/bin"
    "/opt/gomicro/bin"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
  )

  path=""

  for dir in ${paths[@]}; do
    if [[ "$path" != "" ]]; then
      path="${path}:"
    fi

    path="${path}${dir}"
  done

  echo $path
}
