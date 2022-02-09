job "hello_pack" {
    type = "service"
    [[ template "region" . ]]

    datacenters = [ [[ range $i, $dc := .hello_pack.datacenters ]][[if $i]],[[end]][[ $dc | quote ]][[ end ]] ]

    group "app" {
        count = [[ .hello_pack.app_count ]]

        network {
            port "http" {
              static = 80
            }
        }

        [[/*  this is a go template comment */]]

        task "server" {
          driver = "docker"
          config {
            image = "mnomitch/hello_world_server"
            network_mode = "host"
            ports = ["http"]
          }

          resources {
            cpu = [[ .hello_pack.resources.cpu ]]
            memory = [[ .hello_pack.resources.memory ]]
          }
        }
    }
}