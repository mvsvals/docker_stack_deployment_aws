output "web_instances_info" {
  description = "Names, pubprivate IPs of web instances"
  value = [
    for i in aws_instance.web :
    {
      name       = i.tags["Name"]
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }
  ]
}

output "bastion_instance_info" {
  description = "Public IP of the bastion instance"
  value = {
    name      = aws_instance.bastion.tags["Name"]
    public_ip = aws_instance.bastion.public_ip
  }
}

output "db_instance_info" {
  description = "Name and private IP of db instance"
  value = {
    name       = aws_instance.db.tags["Name"]
    private_ip = aws_instance.db.private_ip
  }
}
