import json
import boto3
import os

# Get DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='eu-west-3')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # Extract the FeedbackID from the path parameters
    feedback_id = event['pathParameters'].get('id')
    
    if not feedback_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'FeedbackID is required'})
        }

    # Parse the body for new field values
    try:
        body = json.loads(event['body'])
    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid JSON in request body', 'error': str(e)})
        }
    
    # Use scan to find the item with the given FeedbackID
    try:
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

        # If the item exists, retrieve the keys
        item = response['Items'][0]
        user = item.get('User')  

        # Update the item in DynamoDB
        update_expression = "SET " + ", ".join(f"#{key} = :{key}" for key in body.keys())
        expression_attribute_names = {f"#{key}": key for key in body.keys()}
        expression_attribute_values = {f":{key}": value for key, value in body.items()}

        table.update_item(
            Key={
                'FeedbackID': feedback_id,  # Partition key
                'User': user    # Sort key (if applicable)
            },
            UpdateExpression=update_expression,
            ExpressionAttributeNames=expression_attribute_names,
            ExpressionAttributeValues=expression_attribute_values
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Feedback updated successfully ✅'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Failed to update feedback', 'error': str(e)})
        }
