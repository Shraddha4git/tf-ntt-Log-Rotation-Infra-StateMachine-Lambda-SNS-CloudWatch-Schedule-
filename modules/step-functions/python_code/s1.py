import boto3
import os

TG1_ARN = os.getenv("TG1_ARN", "")
TG2_ARN = os.getenv("TG2_ARN", "")
ALB_LISTENER_ARN = os.getenv("ALB_LISTENER_ARN", "")
SNS_TOPIC_ARN = os.getenv("SNS_TOPIC_ARN", "")
TG1_INSTANCE_IDS = [id.strip() for id in os.getenv("TG1_INSTANCE_IDS", "").split(",")]
TG2_INSTANCE_IDS = [id.strip() for id in os.getenv("TG2_INSTANCE_IDS", "").split(",")]

client = boto3.client('elbv2')

def check_health(target_group_arn):
    response = client.describe_target_health(TargetGroupArn=target_group_arn)
    healthy_targets = [target['Target']['Id'] for target in response['TargetHealthDescriptions']
                       if target['TargetHealth']['State'] == 'healthy']
    unhealthy_targets = [target['Target']['Id'] for target in response['TargetHealthDescriptions']
                         if target['TargetHealth']['State'] in ['unhealthy', 'unavailable']]
    return healthy_targets, unhealthy_targets

def lambda_handler(event, context):
    tg2_instance_health, request_timeout_targets = check_health(TG2_ARN)
    retry_count = event.get("s1-RetryCount", 0)
    event["s1-RetryCount"] = retry_count + 1
    event["Unhealthy_Instances"] = request_timeout_targets
    
    if not tg2_instance_health:
        event["Tg2_Instance_Status"] = "Unhealthy"
    else:
        event["Tg2_Instance_Status"] = "Healthy"
    
    return event
