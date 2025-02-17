
provider "docker" {
  host = var.docker_socket
}

resource "docker_image" "busybox" {
  name = "busybox:latest"
}

resource "docker_container" "example" {
  name    = "example-container"
  image   = docker_image.busybox.latest
  command = ["echo", "Hello, Docker!"]
  depends_on = [docker_image.busybox]
}
