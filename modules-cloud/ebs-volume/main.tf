
######################################   AWS EC2 - EBS ##########################33


resource "aws_ebs_volume" "ebs_volume" {
 availability_zone = "us-east-1a"
 size = 1
 encrypted = true

 tags = {
  Name = "My_Test_EBS_Volume"
 }
}


#Attaching EC2 and EBS 


resource "aws_volume_attachment" "ebs_attachment" {
  device_name =  "/dev/sdh"
  volume_id = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.server.id
}