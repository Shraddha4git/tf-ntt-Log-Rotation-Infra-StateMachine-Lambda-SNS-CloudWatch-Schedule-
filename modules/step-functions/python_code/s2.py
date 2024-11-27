import boto3
import os

TG1_ARN = os.getenv("TG1_ARN", "")
TG2_ARN = os.getenv("TG2_ARN", "")
ALB_LISTENER_ARN = os.getenv("ALB_LISTENER_ARN", "")
TG1_INSTANCE_IDS = [id.strip() for id in os.getenv("TG1_INSTANCE_IDS", "").split(",")]
TG2_INSTANCE_IDS = [id.strip() for id in os.getenv("TG2_INSTANCE_IDS", "").split(",")]

client = boto3.client('elbv2')

def traffic_shift_to_tg2(step):
    steps = [
        {"TG1_Weight": 50, "TG2_Weight": 50},
        {"TG1_Weight": 0, "TG2_Weight": 100}
    ]
    
    try:
        step_config = steps[step]
        print(f"Shifting traffic: TG1 = {step_config['TG1_Weight']}%, TG2 = {step_config['TG2_Weight']}%")
        client.modify_listener(
            ListenerArn=ALB_LISTENER_ARN,
            DefaultActions=[
                {
                    'Type': 'forward',
                    'ForwardConfig': {
                        'TargetGroups': [
                            {
                                'TargetGroupArn': TG1_ARN,
                                'Weight': step_config['TG1_Weight']
                            },
                            {
                                'TargetGroupArn': TG2_ARN,
                                'Weight': step_config['TG2_Weight']
                            }
                        ]
                    }
                }
            ]
        )
        return {"s2-TrafficShiftStatus": "Success", "s2-Step": step + 1}

    except Exception as ex:
        error_message = f"Exception occurred during traffic shift: {str(ex)}"
        return {"s2-TrafficShiftStatus": "Failed"}

def lambda_handler(event, context):
    step = event.get("s2-Step", 0)
    result = traffic_shift_to_tg2(step)
    event.update(result)
    return event
