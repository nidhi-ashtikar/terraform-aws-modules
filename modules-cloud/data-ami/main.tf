
data "aws_ami" "aws_ami" {
  most_recent = true
  owners      = ["amazon"] # Specify the owner (e.g., "amazon" for official AMIs)
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] //new ami 
    #values = ["amzn2-ami-hvm-*"]  # Replace with the desired AMI name
  }
  // adding additional filter
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}