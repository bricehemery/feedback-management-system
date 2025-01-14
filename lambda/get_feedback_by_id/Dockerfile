FROM public.ecr.aws/lambda/python:3.8

# Set work directory
WORKDIR /var/task

# Copy application code and dependencies
COPY handler.py ./
# COPY ../lambda_layer/python /opt/python

# Set the command for AWS Lambda runtime
CMD ["handler.lambda_handler"]