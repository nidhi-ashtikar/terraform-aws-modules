# #Note:
# #You must specify either launch_configuration, launch_template, or mixed_instances_policy.


# resource "aws_launch_configuration" "lc" {
#   name            = "launchconfig"
#   image_id        = data.aws_ami.aws_ami.id
#   instance_type   = "t2.micro"
#   security_groups = [aws_security_group.sg.id]

#   user_data = <<-EOF
#     #!/bin/bash
#     sudo yum update -y
#     sudo yum install -y httpd
#     sudo systemctl start httpd
#     sudo systemctl enable httpd
#     echo "Hello from Instance" > /var/www/html/index.html

# EOF 

#   lifecycle {
#     create_before_destroy = true
#   }
# }



# #----------------------------Auto Scaling Group 

# resource "aws_autoscaling_group" "ag" {
#   name     = "ag"
#   max_size = 4
#   min_size = 1
#   launch_configuration      = aws_launch_configuration.lc.id
#   vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
#   health_check_type         = "ELB"
#   health_check_grace_period = "300"

#   tag {
#     key                 = "Name"
#     value               = "app-instance"
#     propagate_at_launch = true
#   }

#   target_group_arns = [aws_lb_target_group.target-group.id]
# }


# # #----------------------------Auto Scaling Policy (Default)

# # resource "aws_autoscaling_policy" "agp-out" {
# #   name                   = "scaleout"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   adjustment_type        = "ChangeInCapacity"
# #   scaling_adjustment     = 1
# #   cooldown               = 300
# # }


# # resource "aws_autoscaling_policy" "agp-in" {
# #   name                   = "scalein"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   adjustment_type        = "ChangeInCapacity"
# #   scaling_adjustment     = -1
# #   cooldown               = 300
# # }

# #----------------------------Auto Scaling - ELB - Attachment 

# resource "aws_autoscaling_attachment" "ag-attachment" {
#   autoscaling_group_name = aws_autoscaling_group.ag.id
#   lb_target_group_arn    = aws_lb_target_group.target-group.id
# }






# # #----------------------------Auto Scaling Policy (Scheduled Scaling)


# # resource "aws_autoscaling_schedule" "scale_up_morning" {
# #   scheduled_action_name  = "scale-up-morning"
# #   min_size               = 3  # Desired number of instances at the specified time
# #   max_size               = 5
# #   desired_capacity       = 3
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   start_time             = "2024-08-18T09:00:00Z"  # UTC time for scaling up
# # }

# # resource "aws_autoscaling_schedule" "scale_down_evening" {
# #   scheduled_action_name  = "scale-down-evening"
# #   min_size               = 1  # Desired number of instances at the specified time
# #   max_size               = 3
# #   desired_capacity       = 1
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   start_time             = "2024-08-18T21:00:00Z"  # UTC time for scaling down
# # }

# # #----------------------------Auto Scaling Policy (Predictive Scaling)

# # resource "aws_autoscaling_policy" "predictive_scaling" {
# #   name                   = "predictive-scaling-policy"
# #   policy_type            = "PredictiveScaling"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name

# #   predictive_scaling_configuration {
# #     metric_specification {
# #       target_value = 50.0  # Target value for the metric (e.g., CPU utilization)

# #       predefined_metric_pair_specification {
# #         predefined_metric_type = "ASGAverageCPUUtilization"
# #       }
# #     }

# #     mode = "ForecastAndScale"  # Mode for Predictive Scaling. Options: ForecastOnly, ForecastAndScale

# #     scheduling_buffer_time = 300  # Optional buffer time to avoid too aggressive scaling actions
# #   }
# # }



# # #----------------------------Auto Scaling Policy (Simple Scaling)

# # resource "aws_autoscaling_policy" "ascaling-scale_up" {
# #   name =  "simple-up-scaling"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   policy_type = "SimpleScaling"
# #   scaling_adjustment = 1
# #   adjustment_type = "ChangeInCapacity"
# #   cooldown = 300

# # }

# # resource "aws_autoscaling_policy" "ascaling-scale_down" {
# #   name =  "simple-down-scaling"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   policy_type = "SimpleScaling"
# #   scaling_adjustment = -1
# #   adjustment_type = "ChangeInCapacity"
# #   cooldown = 300

# # }

# # # #---------Auto Scaling Policy -CloudWatch Alarms - for Simple Scaling



# # resource "aws_cloudwatch_metric_alarm" "scaleup" {
# #   alarm_name          = "scale-up-alarm"
# #   comparison_operator = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods = "1"
# #   metric_name         = "CPUUtilization"
# #   namespace = "AWS/EC2"
# #   period = "60"
# #   statistic = "Average"
# #   threshold = "80"

# #   alarm_actions = [aws_autoscaling_policy.ascaling-scale_up.arn]
# #   ok_actions = [aws_autoscaling_policy.ascaling-scale_down.arn]

# # }

# # resource "aws_cloudwatch_metric_alarm" "scaledown" {
# #   alarm_name          = "scale-down-alarm"
# #   comparison_operator = "LessThanOrEqualToThreshold"
# #   evaluation_periods = "1"
# #   metric_name         = "CPUUtilization"
# #   namespace = "AWS/EC2"
# #   period = "60"
# #   statistic = "Average"
# #   threshold = "20"

# #   alarm_actions = [aws_autoscaling_policy.ascaling-scale_down.arn]
# #   ok_actions = [aws_autoscaling_policy.ascaling-scale_up.arn]

# # }

# #-------------------------------------------------------------------------------

# # #----------------------------Auto Scaling Policy (Step Scaling)



# # resource "aws_autoscaling_policy" "scale_up" {
# #     name =  "scale-up-policy"
# #     autoscaling_group_name = aws_autoscaling_group.ag.name
# #     policy_type = "StepScaling"
# #     scaling_adjustment = 1
# #     adjustment_type = "ChangeInCapacity"
# #     cooldown = 300

# #     step_adjustment {
# #     metric_interval_upper_bound = "10"
# #     scaling_adjustment = 1
# #   }

# #   step_adjustment {
# #     metric_interval_upper_bound = "20"
# #     scaling_adjustment = 2
# #   }

# #   step_adjustment {
# #     metric_interval_upper_bound = "30"
# #     scaling_adjustment = 3
# #   }
# # }

# # resource "aws_autoscaling_policy" "scale_down" {
# #   name                   = "scale-down-policy"
# #   scaling_adjustment     = -1
# #   adjustment_type        = "ChangeInCapacity"
# #   cooldown               = 300
# #   autoscaling_group_name = aws_autoscaling_group.ag.name
# #   policy_type            = "StepScaling"

# #   step_adjustment {
# #     metric_interval_upper_bound = "10"
# #     scaling_adjustment = -1
# #   }

# #   step_adjustment {
# #     metric_interval_upper_bound = "20"
# #     scaling_adjustment = -2
# #   }

# #   step_adjustment {
# #     metric_interval_upper_bound = "30"
# #     scaling_adjustment = -3
# #   }
# # }

# # # # #---------Auto Scaling Policy -CloudWatch Alarms - for step Scaling


# # resource "aws_cloudwatch_metric_alarm" "scaleup" {
# #   alarm_name          = "high-cpu-alarm"
# #   comparison_operator = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods = "1"
# #   metric_name         = "CPUUtilization"
# #   namespace = "AWS/EC2"
# #   period = "60"
# #   statistic = "Average"
# #   threshold = "80"

# #   alarm_actions = [aws_autoscaling_policy.ascaling-scale_up.id]

# # }

# # resource "aws_cloudwatch_metric_alarm" "scaledown" {
# #   alarm_name          = "low-cpu-alarm"
# #   comparison_operator = "LessThanOrEqualToThreshold"
# #   evaluation_periods = "1"
# #   metric_name         = "CPUUtilization"
# #   namespace = "AWS/EC2"
# #   period = "60"
# #   statistic = "Average"
# #   threshold = "20"

# #   alarm_actions = [aws_autoscaling_policy.ascaling-scale_down.id]

# # }

# # #----------------------------Auto Scaling Policy (target_tracking Scaling)


# # resource "aws_autoscaling_policy" "target_tracking" {
# #   name                   = "target-tracking-scaling-policy"
# #   policy_type            = "TargetTrackingScaling"
# #   adjustment_type        = "ChangeInCapacity"
# #   autoscaling_group_name = aws_autoscaling_group.ag.name

# #   target_tracking_configuration {
# #     predefined_metric_specification {
# #       predefined_metric_type = "ASGAverageCPUUtilization"
# #     }
# #     target_value = 50.0  # Set the desired average CPU utilization percentage
# #   }
# # }



