import json
import boto3
import os

# Get DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # Extract the FeedbackID from path parameters
    feedback_id = event['pathParameters'].get('id')
    
    if not feedback_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'FeedbackID is required'})
        }

    # Use scan to find the item with the given FeedbackID
    try:
        # Perform scan to find the item by FeedbackID (since it's unique, it should be one result)
        response = table.scan(
            FilterExpression='FeedbackID = :feedback_id',
            ExpressionAttributeValues={':feedback_id': feedback_id}
        )
        
        # Check if the item exists
        if not response['Items']:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Feedback not found'})
            }

        # If the item exists, retrieve the partition key and sort key
        item = response['Items'][0]
        feedback_id = item['FeedbackID']
        user = item.get('User') 
        
        # Delete the item from DynamoDB
        table.delete_item(
            Key={
                'FeedbackID': feedback_id,  # Partition key
                'User': user    # Sort key
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Feedback deleted successfully ✅'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Failed to delete feedback', 'error': str(e)})
        }
