

# #################### AWS EFS  ##########################

# resource "aws_efs_file_system" "efs" {

#   availability_zone_name = "us-west-2a"
#   creation_token = "My-Token"
#   encrypted = true

#   lifecycle_policy {
#     transition_to_ia =  "AFTER_30_DAYS"
#     transition_to_archive = "AFTER_90_DAYS"
#     transition_to_primary_storage_class = "AFTER_1_ACCESS"
#   }

#   throughput_mode = "elastic" #bursting (By Default) OR  provisioned
#   performance_mode = "generalPurpose" #(By Default)




#   tags = {
#     Name = "My-EFS"
#   }
# }


# #########----------- Security Group for EFS:

# resource "aws_security_group" "efs_sg" {
#   name = "efs_sg"
#   description = "EFS security group"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     from_port   = 2049 #The default port of NFS server listening
#     to_port     = 2049
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }

# ######## --- VPC 

# resource "aws_vpc" "vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# ######## --- Subnet 

# resource "aws_subnet" "subnet" {
#   vpc_id            = aws_vpc.vpc.id
#   availability_zone = "us-west-2a"
#   cidr_block        = "10.0.1.0/24"
# }

# ######## --- Mount Target  

# resource "aws_efs_mount_target" "efs_mount_target" {
#   file_system_id = aws_efs_file_system.efs.id
#   subnet_id      = aws_subnet.subnet.id
#   security_groups = [aws_security_group.efs_sg.id]
# }

# ########## ------- Create EC2 Instances and Mount EFS  ---------##############


# resource "aws_instance" "ec2-for-efs" {
#   count = 2
#   ami = data.aws_ami.aws_ami.id
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.subnet.id
#   security_groups = [aws_security_group.efs_sg.id]


# user_data = <<-EOF
#                 #!/bin/bash
#                 yum install -y amazon-efs-utils    
#                 mkdir /mnt/efs
#                 mount -t efs ${aws_efs_file_system.efs.id}:/ /mnt/efs
#                 echo "${aws_efs_file_system.efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
#               EOF
# tags = {
#   Name = "My-EC2-${count.index}"
# }
# }

# #yum install -y amazon-efs-utils - Installs the Amazon EFS (Elastic File System) utilities package.
# # mkdir /mnt/efs -  Creates a directory to serve as the mount point for the EFS file system

# # mount -t efs ${aws_efs_file_system.efs.id}:/ /mnt/efs 
# #Purpose: Mounts the EFS file system to the directory created in the previous step.


# #mount is the command to mount a file system.
# #-t efs specifies the type of file system, which is EFS in this case.
# #${aws_efs_file_system.efs.id}:/ is the EFS file system ID, dynamically inserted by Terraform.
# #/mnt/efs is the mount point directory.


# #echo "${aws_efs_file_system.efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab:
# #Purpose: Ensures the EFS file system is automatically mounted on system reboot.


# #"${aws_efs_file_system.efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" is the entry to be added to the /etc/fstab file.
# #>> /etc/fstab appends the entry to the /etc/fstab file, which is used by the system to mount file systems at boot time.
