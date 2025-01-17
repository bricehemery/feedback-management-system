FROM public.ecr.aws/lambda/python:3.8

# Set work directory
WORKDIR /var/task

# Cop dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Set the command for AWS Lambda runtime
CMD ["handler.lambda_handler"]