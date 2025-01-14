import json
import boto3
import os

# Get DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='eu-west-3')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # Extract the FeedbackID from path parameters
    feedback_id = event['pathParameters'].get('id')

    if not feedback_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'FeedbackID is required'})
        }

    # Perform a Scan to find feedback with the matching FeedbackID
    try:
        response = table.scan(
            FilterExpression='FeedbackID = :feedback_id',
            ExpressionAttributeValues={':feedback_id': feedback_id}
        )
        
        # Check if the feedback is found
        if response.get('Items'):
            item = response['Items'][0]
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Feedback retrieved successfully ✅', 'feedback': item})
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Feedback not found'})
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Failed to retrieve feedback', 'error': str(e)})
        }
