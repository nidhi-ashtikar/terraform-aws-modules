

#################################  AWS EC2 - EBS - SNAPSHOT ##########################


resource "aws_ebs_snapshot" "ebs_volume_snap" {
  volume_id = aws_ebs_volume.ebs_volume.id
  storage_tier = "archive"  #EBS Snapshot Archive

##### Protect EBS snapshots from accidental deletion  ######

  lifecycle {
    prevent_destroy = false
  }

#If you need to remove the resource, you would have to first remove or set prevent_destroy to false in the configuration, then apply the changes.

  tags = {
    Name = "My_Test_EBS_Volume_Snap"
  }
}


#################### AWS EC2 - EBS -COPY SNAPSHOT to Another Region ##########################


resource "aws_ebs_snapshot_copy" "ebs_volume_snap_copy" {
  source_snapshot_id = aws_ebs_snapshot.ebs_volume_snap.id
  source_region = "us-east-1"

  tags= {
    Name = "My_Test_EBS_Volume_Snap_Copy"
  }
}

#################### AWS EC2 - EBS - ##########################

##Create a new EBS volume from an existing snapshot in a different Availability Zone##


resource "aws_ebs_volume" "new_volume" {
  availability_zone = "us-east-1c"
  snapshot_id = aws_ebs_snapshot.ebs_volume_snap.id
  size = 2
  encrypted = true


  tags = {
    Name= "New _ Volume_From _Snapshot"
  }
}