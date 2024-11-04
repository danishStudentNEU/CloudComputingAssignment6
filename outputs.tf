output "instance_public_ip" {
  description = "The public IP address of the web server instance"
  value       = aws_instance.web_server.public_ip
}