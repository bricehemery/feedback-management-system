import json
import uuid
import boto3
import os
from datetime import datetime

# Get DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # Parse incoming event (API Gateway)
    body = json.loads(event['body'])

    # Collect data from event
    feedback_id = str(uuid.uuid4())
    user = body.get('User', 'Anonymous')
    message = body['Message']
    rating = body['Rating']
    timestamp = datetime.now().isoformat()

    # Prepare the data to be written to DynamoDB
    item = {
        'FeedbackID': feedback_id,
        'User': user,
        'Message': message,
        'Rating': rating,
        'Timestamp': timestamp
    }

    # Write the data to DynamoDB
    try:
        table.put_item(Item=item)
        response = {
            'statusCode': 200,
            'body': json.dumps({'message': 'Feedback submitted successfully!', 'inserted_item': item})
        }
    except Exception as e:
        response = {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

    return response
