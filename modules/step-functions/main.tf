# s2.py to s10.py archive configurations
data "archive_file" "s0_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s0.py"
  output_path  = "${path.module}/python_code/s0.zip"
}

data "archive_file" "s1_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s1.py"
  output_path  = "${path.module}/python_code/s1.zip"
}

data "archive_file" "s2_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s2.py"
  output_path  = "${path.module}/python_code/s2.zip"
}

data "archive_file" "s3_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s3.py"
  output_path  = "${path.module}/python_code/s3.zip"
}

data "archive_file" "s4_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s4.py"
  output_path  = "${path.module}/python_code/s4.zip"
}
/*
data "archive_file" "s5_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s5.py"
  output_path  = "${path.module}/python_code/s5.zip"
}
*/
data "archive_file" "s6_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s6.py"
  output_path  = "${path.module}/python_code/s6.zip"
}

data "archive_file" "s7_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s7.py"
  output_path  = "${path.module}/python_code/s7.zip"
}

data "archive_file" "s8_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s8.py"
  output_path  = "${path.module}/python_code/s8.zip"
}

/*
data "archive_file" "s10_zip" {
  type         = "zip"
  source_file  = "${path.module}/python_code/s10.py"
  output_path  = "${path.module}/python_code/s10.zip"
}*/

resource "aws_s3_bucket" "s3_lambda_function_files" {
  bucket        = "tf-ebs-lambda-function-03-10-24"
  force_destroy = true

  tags = {
    Name        = "App Deployment Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "logs_folder" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "logs/"  # This creates a 'folder' in S3
  acl    = "private"
}

resource "aws_s3_object" "s0_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s0.zip"
  source = "${path.module}/python_code/s0.zip"
}

resource "aws_s3_object" "s1_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s1.zip"
  source = "${path.module}/python_code/s1.zip"
}

resource "aws_s3_object" "s2_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s2.zip"
  source = "${path.module}/python_code/s2.zip"
}

resource "aws_s3_object" "s3_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s3.zip"
  source = "${path.module}/python_code/s3.zip"
}

resource "aws_s3_object" "s4_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s4.zip"
  source = "${path.module}/python_code/s4.zip"
}
/*
resource "aws_s3_object" "s5_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s5.zip"
  source = "${path.module}/python_code/s5.zip"
}
*/
resource "aws_s3_object" "s6_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s6.zip"
  source = "${path.module}/python_code/s6.zip"
}

resource "aws_s3_object" "s7_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s7.zip"
  source = "${path.module}/python_code/s7.zip"
}

resource "aws_s3_object" "s8_upload" {
  bucket = aws_s3_bucket.s3_lambda_function_files.bucket
  key    = "s8.zip"
  source = "${path.module}/python_code/s8.zip"
}

# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_exec" {
  name = "tf-lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{

      Effect = "Allow"
      Action = [
         "sts:AssumeRole"],
         Principal= {
          Service = "lambda.amazonaws.com"
         },
         "Action": "sts:AssumeRole"
    },
    { "Effect": "Allow",
     "Principal": { "Service": "states.amazonaws.com" 
     }, 
     "Action": "sts:AssumeRole" 
     }
     ]
  })
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
   name = "tf-lambda_role_policy"
   role = aws_iam_role.lambda_exec.id
   
policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup", 
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups", 
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "ssm:SendCommand",
          "ssm:ListCommandInvocations",
          "states:StartExecution", 
          "states:DescribeExecution", 
          "states:DescribeStateMachine", 
          "states:ListExecutions",
          "states:ListStateMachines"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "lambda:InvokeFunction",
        "Resource": [
        "arn:aws:lambda:ap-south-1:308521642984:function:s1",
        "arn:aws:lambda:ap-south-1:308521642984:function:s2",
        "arn:aws:lambda:ap-south-1:308521642984:function:s3",
        "arn:aws:lambda:ap-south-1:308521642984:function:s4",
        "arn:aws:lambda:ap-south-1:308521642984:function:s5",
        "arn:aws:lambda:ap-south-1:308521642984:function:s6",
        "arn:aws:lambda:ap-south-1:308521642984:function:s7",
        "arn:aws:lambda:ap-south-1:308521642984:function:s8",
        "arn:aws:lambda:ap-south-1:308521642984:function:s9",
        "arn:aws:lambda:ap-south-1:308521642984:function:s10"        
        ]
      },
      {
        "Effect": "Allow",
        "Action": "sns:Publish",
        "Resource": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      }
    ] 
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "s0" {
  depends_on = [aws_s3_object.s0_upload]
  function_name    = "s0"
  handler          = "s0.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s0.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s1" {
  depends_on = [aws_s3_object.s1_upload]
  function_name    = "s1"
  handler          = "s1.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s1.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s2" {
  depends_on = [aws_s3_object.s2_upload]
  function_name    = "s2"
  handler          = "s2.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s2.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s3" {
  depends_on = [aws_s3_object.s3_upload]
  function_name    = "s3"
  handler          = "s3.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s3.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s4" {
  depends_on = [aws_s3_object.s4_upload]
  function_name    = "s4"
  handler          = "s4.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s4.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}
/*
resource "aws_lambda_function" "s5" {
  depends_on = [aws_s3_object.s5_upload]
  function_name    = "s5"
  handler          = "s5.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s5.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}
*/
resource "aws_lambda_function" "s6" {
  depends_on = [aws_s3_object.s6_upload]
  function_name    = "s6"
  handler          = "s6.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s6.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s7" {
  depends_on = [aws_s3_object.s7_upload]
  function_name    = "s7"
  handler          = "s7.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s7.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s8" {
  depends_on = [aws_s3_object.s8_upload]
  function_name    = "s8"
  handler          = "s8.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s8.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}
/*
resource "aws_lambda_function" "s9" {
  depends_on = [aws_s3_object.s9_upload]
  function_name    = "s9"
  handler          = "s9.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s9.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}

resource "aws_lambda_function" "s10" {
  depends_on = [aws_s3_object.s10_upload]
  function_name    = "s10"
  handler          = "s10.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 850
  s3_bucket        = "tf-ebs-lambda-function-03-10-24"
  s3_key           = "s10.zip"
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.ec2_security_group_id]
  }
  environment {
    variables = {
      TG1_INSTANCE_IDS = join(", ", var.tg1_instance_ids)
      TG2_INSTANCE_IDS = join(", ", var.tg2_instance_ids)
      TG1_ARN          = var.tg1_arn
      TG2_ARN          = var.tg2_arn
      ALB_LISTENER_ARN = var.listener_arn
      SNS_TOPIC_ARN = var.SNS_TOPIC_ARN
    }
  }
}*/


resource "aws_iam_role" "step_functions_role" {
  name = "tf-step-functions-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "step_functions_policy" {
  name = "tf-step-functions-policy"
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "states:StartExecution",
          "states:DescribeExecution",
          "states:DescribeStateMachine",
          "states:ListExecutions",
          "states:ListStateMachines",
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "logs:CreateLogDelivery",
                "logs:CreateLogStream",
                "logs:GetLogDelivery",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:ListLogDeliveries",
                "logs:PutLogEvents",
                "logs:PutResourcePolicy",
                "logs:DescribeResourcePolicies",
                "logs:DescribeLogGroups",

        ],
        "Resource": "*"
      }
    ]
  })
}


# Step Functions State Machine
resource "aws_sfn_state_machine" "state_machine-test" {
  name     = "tf-StateMachine-log-rotation-10-step-function-test"
  role_arn = aws_iam_role.step_functions_role.arn
  # definition = file("./module/python_code/new-state.json")
  definition = <<EOF
  {
  "Comment": "State Machine for invoking Lambda functions sequentially with choices and retries.",
  "StartAt": "S1-Health-Check-Tg2",
  "States": {
    "S1-Health-Check-Tg2": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s1",
      "Next": "Tg2_Instance_Status_Choice"
    },
    "Tg2_Instance_Status_Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.Tg2_Instance_Status",
          "StringEquals": "Unhealthy",
          "Next": "s1-tg2-RetryOrNotify"
        }
      ],
      "Default": "S2-Traffic-Routing-Tg2"
    },
    "s1-tg2-RetryOrNotify": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s1-RetryCount",
          "NumericGreaterThanEquals": 20,
          "Next": "s1-SendMailSNS"
        }
      ],
      "Default": "S1-WaitForTG2Health"
    },
    "S1-WaitForTG2Health": {
      "Type": "Wait",
      "Seconds": 60,
      "Next": "S1-Health-Check-Tg2"
    },
    "S2-Traffic-Routing-Tg2": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s2",
      "Next": "Check_Traffic_Shift_to_Tg2_Step1"
    },
    "Check_Traffic_Shift_to_Tg2_Step1": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s2-TrafficShiftStatus",
          "StringEquals": "Failed",
          "Next": "s2-SendMailSNS"
        }
      ],
      "Default": "S2-WaitStep1"
    },
    "S2-WaitStep1": {
      "Type": "Wait",
      "Seconds": 20,
      "Next": "S2-Traffic-Routing-Tg2-Step2"
    },
    "S2-Traffic-Routing-Tg2-Step2": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s2",
      "Next": "Check_Traffic_Shift_to_Tg2_Step2"
    },
    "Check_Traffic_Shift_to_Tg2_Step2": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s2-TrafficShiftStatus",
          "StringEquals": "Failed",
          "Next": "s2-SendMailSNS"
        }
      ],
      "Default": "S2-WaitStep2"
    },
    "S2-WaitStep2": {
      "Type": "Wait",
      "Seconds": 20,
      "Next": "S3-Health-Check-Tg1"
    },
    "S3-Health-Check-Tg1": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s3",
      "Next": "Tg1_Instance_Status_Choice"
    },
    "Tg1_Instance_Status_Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.Tg1_Instance_Status",
          "StringEquals": "Unhealthy",
          "Next": "tg1-RetryOrNotify"
        }
      ],
      "Default": "S4-Tg1-Restart-Script"
    },
    "tg1-RetryOrNotify": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s3-RetryCount",
          "NumericGreaterThanEquals": 20,
          "Next": "s3-SendMailSNS"
        }
      ],
      "Default": "S3-WaitForTG1Health"
    },
    "S3-WaitForTG1Health": {
      "Type": "Wait",
      "Seconds": 60,
      "Next": "S3-Health-Check-Tg1"
    },
    "S4-Tg1-Restart-Script": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s4",
      "Next": "IsScriptExecutedChoice"
    },
    "IsScriptExecutedChoice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s4-ScriptExecutionStatus",
          "StringEquals": "Fail",
          "Next": "RetryScriptExecution"
        }
      ],
      "Default": "S4-WaitAfterRestart"
    },
    "S4-WaitAfterRestart": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "S5-Health-Check-Tg1-repeat"
    },
    "RetryScriptExecution": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s4-RetryCount",
          "NumericGreaterThanEquals": 40,
          "Next": "s4-SendMailSNS"
        }
      ],
      "Default": "S4-Tg1-Restart-Script"
    },
    "S5-Health-Check-Tg1-repeat": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s3",
      "Next": "Tg1_Instance_Status_Choice_Repeat"
    },
    "Tg1_Instance_Status_Choice_Repeat": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.Tg1_Instance_Status",
          "StringEquals": "Unhealthy",
          "Next": "tg1-RetryOrNotify-repeat"
        }
      ],
      "Default": "S6-Traffic-Routing-Tg1"
    },
    "tg1-RetryOrNotify-repeat": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s3-RetryCount",
          "NumericGreaterThanEquals": 20,
          "Next": "s3-SendMailSNS"
        }
      ],
      "Default": "S5-WaitForTG1Health"
    },
    "S5-WaitForTG1Health": {
      "Type": "Wait",
      "Seconds": 60,
      "Next": "S5-Health-Check-Tg1-repeat"
    },
    "S6-Traffic-Routing-Tg1": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s6",
      "Next": "Check_Traffic_Shift_to_Tg1_Step1"
    },
    "Check_Traffic_Shift_to_Tg1_Step1": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s6-TrafficShiftStatus",
          "StringEquals": "Failed",
          "Next": "s6-SendMailSNS"
        }
      ],
      "Default": "S6-WaitStep1"
    },
    "S6-WaitStep1": {
      "Type": "Wait",
      "Seconds": 120,
      "Next": "S6-Traffic-Routing-Tg1-Step2"
    },
    "S6-Traffic-Routing-Tg1-Step2": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s6",
      "Next": "Check_Traffic_Shift_to_Tg1_Step2"
    },
    "Check_Traffic_Shift_to_Tg1_Step2": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s6-TrafficShiftStatus",
          "StringEquals": "Failed",
          "Next": "s6-SendMailSNS"
        }
      ],
      "Default": "S6-WaitStep2"
    },
    "S6-WaitStep2": {
      "Type": "Wait",
      "Seconds": 120,
      "Next": "S7-Tg2-Restart-Script"
    },
    "S7-Tg2-Restart-Script": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s7",
      "Next": "S7-IsScriptExecutedChoice"
    },
    "S7-IsScriptExecutedChoice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s7-ScriptExecutionStatus",
          "StringEquals": "Fail",
          "Next": "S7-RetryScriptExecution"
        }
      ],
      "Default": "S7-WaitAfterRestart"
    },
    "S7-RetryScriptExecution": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s7-RetryCount",
          "NumericGreaterThanEquals": 40,
          "Next": "s7-SendMailSNS"
        }
      ],
      "Default": "S7-Tg2-Restart-Script"
    },
    "S7-WaitAfterRestart": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "S8-Stop-Tg2"
    },
    "S8-Stop-Tg2": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:ap-south-1:308521642984:function:s8",
      "Next": "Stop_Tg2_Instance"
    },
    "Stop_Tg2_Instance": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.StopTg2Status",
          "StringEquals": "Notokay",
          "Next": "s8-WaitAndRetry"
        }
      ],
      "Default": "SuccessState"
    },
    "s8-WaitAndRetry": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.s8-RetryCount",
          "NumericGreaterThan": 60,
          "Next": "s8-SendMailSNS"
        }
      ],
      "Default": "S8-Stop-Tg2"
    },
    "s1-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s1- Max Retry Count Reached - TG2 Unhealthy",
        "Subject": "s1- Max Retry Count Reached - TG2 Unhealthy",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s2-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s2- Max Retry Count Reached - Traffic Routing Failed from TG1 to TG2",
        "Subject": "s2- Max Retry Count Reached - Traffic Routing Failed from TG1 to TG2",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s3-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s3- Max Retry Count Reached - TG1 Unhealthy",
        "Subject": "s3- Max Retry Count Reached - TG1 Unhealthy",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s4-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s4 - TG2 Log Rotation Failed",
        "Subject": "s4 - TG2 Restart Script Execution Failed",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s6-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s7- Max Retry Count Reached - Traffic Routing Failed from TG2 to TG1 $.s7-TrafficShiftError",
        "Subject": "s7- Max Retry Count Reached - Traffic Routing Failed from TG2 to TG1",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s7-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "s4 - TG2 Log Rotation Failed",
        "Subject": "s4 - TG2 Restart Script Execution Failed",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "s8-SendMailSNS": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message": "Stopping TG2 instances failed, retry limit exceeded.",
        "Subject": "Stopping TG2 Instances Failure",
        "TopicArn": "arn:aws:sns:ap-south-1:308521642984:tf-error-ots-log-rotation"
      },
      "Next": "FailState"
    },
    "FailState": {
      "Type": "Fail"
    },
    "SuccessState": {
      "Type": "Succeed"
    }
  }
}
EOF
}

# CloudWatch Event Rules for scheduled triggers
resource "aws_cloudwatch_event_rule" "schedule_s0" {
  name                = "s0"
  schedule_expression = "cron(10 18,2,10 * * ? *)" # This is schedules 20 min before Log Rotation.
}

# CloudWatch Event Targets
resource "aws_cloudwatch_event_target" "s0-start-tg2-check-tomcat_target" {
  rule      = aws_cloudwatch_event_rule.schedule_s0.name
  target_id = "s0"
  arn       = aws_lambda_function.s0.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_s0" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s0.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_s0.arn
}

# Create a CloudWatch Event Rule to trigger the state machine
resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name     = "schedule_rule"
  description = "Triggers the state machine at 00:00, 08:00, and 16:00 IST"
  schedule_expression = "cron(30 18,2,10 * * ? *)" 
}

# Create a CloudWatch Target for the Event Rule
resource "aws_cloudwatch_event_target" "state_machine_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  target_id = "state_machine_target"
  arn       = aws_sfn_state_machine.state_machine-test.arn
}

# Grant permission to the Event Rule to invoke the state machine
resource "aws_cloudwatch_event_permission" "state_machine_permission" {
  statement_id  = "AllowExecution"
  action        = "events:StartExecution"
  principal     = "*"
}
