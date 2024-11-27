
resource "aws_sns_topic" "tf-error-ots-log-rotation" {
  name = "tf-error-ots-log-rotation"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.tf-error-ots-log-rotation.arn
  protocol  = "email"
  endpoint  = "shraddha.suryawanshi@atomtech.in" # Replace with your email
}

# Publish policies to allow SNS to publish messages
resource "aws_sns_topic_policy" "my_notification_topic_policy" {
  arn = aws_sns_topic.tf-error-ots-log-rotation.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sns:Publish",
        Resource = aws_sns_topic.tf-error-ots-log-rotation.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn": "*"
          }
        }
      }
    ]
  })
}

output "SNS_TOPIC_ARN" {
  value = aws_sns_topic.tf-error-ots-log-rotation.arn
}