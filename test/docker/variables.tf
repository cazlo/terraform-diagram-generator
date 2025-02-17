variable docker_socket{
  type = string
  description = "Location of the docker socket, usually unix:///var/run/docker.sock, but may be different for podman and/or rootless contexts"
  default = "unix:///var/run/docker.sock"
}