provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "web-server" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    # EOF es una forma de escribir con saltos de linea sin especificar \n
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World!" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    # Este parametro, define que si se cambia el user_data en el futuro, terraform realizara un delete de la instancia y la volvera a lanzar con el nuevo user_data
    user_data_replace_on_change = true

    tags = "terraform-example"
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress = {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}