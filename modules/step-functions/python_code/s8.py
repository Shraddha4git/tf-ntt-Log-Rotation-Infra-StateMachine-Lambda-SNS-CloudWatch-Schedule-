import boto3
import os

TG2_INSTANCE_IDS = [id.strip() for id in os.getenv("TG2_INSTANCE_IDS", "").split(",")]

# Initialize boto3 EC2 client
ec2_client = boto3.client('ec2')

def stop_instances(instance_ids):
    try:
        response = ec2_client.stop_instances(InstanceIds=instance_ids)
        stopping_instances = response['StoppingInstances']
        stopped = all(instance['CurrentState']['Name'] == 'stopping' for instance in stopping_instances)
        return stopped
    except Exception as e:
        print(f"Error stopping instances: {str(e)}")
        return False

def lambda_handler(event, context):
    retry_count = event.get("s8-RetryCount", 0)

    # Stop TG2 instances
    if stop_instances(TG2_INSTANCE_IDS):
        event["StopTg2Status"] = "Okay"
    else:
        event["StopTg2Status"] = "Notokay"
    
    event["s8-RetryCount"] = retry_count + 1
    return event
