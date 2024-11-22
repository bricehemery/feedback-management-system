import json
import boto3
import os
from decimal import Decimal

# Get DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

# Custom JSON serializer to handle Decimal objects
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            # Convert Decimal to float or int
            return float(obj) if obj % 1 != 0 else int(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    try:
        response = table.scan()
        items = response['Items']
        response = {
            'statusCode': 200,
            'body': json.dumps(
                {'message': 'Feedbacks retrieved successfully ✅', 'feedback': items},
                cls=DecimalEncoder  # Use custom encoder
            )
        }
    except Exception as e:
        response = {
            'statusCode': 500,
            'body': json.dumps({'message': 'Failed to retrieve feedback', 'error': str(e)})
        }

    return response
