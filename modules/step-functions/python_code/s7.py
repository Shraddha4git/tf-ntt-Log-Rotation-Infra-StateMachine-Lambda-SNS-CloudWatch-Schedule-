import boto3
import os

TG1_ARN = os.getenv("TG1_ARN", "")
TG2_ARN = os.getenv("TG2_ARN", "")
ALB_LISTENER_ARN = os.getenv("ALB_LISTENER_ARN", "")
TG1_INSTANCE_IDS = [id.strip() for id in os.getenv("TG1_INSTANCE_IDS", "").split(",")]
TG2_INSTANCE_IDS = [id.strip() for id in os.getenv("TG2_INSTANCE_IDS", "").split(",")]

COMMAND = 'sudo sh /tmp/restart-tomcat.sh'

# Initialize boto3 SSM and SNS clients
ssm_client = boto3.client('ssm')

def run_ssm_command(instance_ids, command):
    response = ssm_client.send_command(
        InstanceIds=instance_ids,
        DocumentName='AWS-RunShellScript',
        Parameters={'commands': [command]}
    )
    command_id = response['Command']['CommandId']
    return command_id

def lambda_handler(event, context):
    try:
        # Run the restart script for TG2
        command_id = run_ssm_command(TG2_INSTANCE_IDS, COMMAND)
        event["CommandId"] = command_id
        event["s7-ScriptExecutionStatus"] = "Success"
    except Exception as e:
        event["s7-ScriptExecutionStatus"] = "Fail"
    return event
