# instance


resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "public-instance"
  }


  user_data = file("${path.module}/script.sh") #bash script 

}

resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name

  subnet_id              = var.private_subnet_id

  tags = {
    Name = "private-instance"
  }

}