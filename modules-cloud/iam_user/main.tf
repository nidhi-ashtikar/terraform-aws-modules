resource "aws_iam_user" "user" {
  name = "sakshi"
  path = "/"

  tags = {
    Department = "developer"
  }
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "example1" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.developers.name
  ]
}


resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "*",
        "Resource": "*"
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}





