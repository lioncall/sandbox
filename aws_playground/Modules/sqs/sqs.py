import boto3
import botostubs

 
queue_url = "	https://sqs.us-east-1.amazonaws.com/287598464817/my-queue"
sqs: botostubs.SQS = boto3.client('sqs')


def send_message(message):
    sqs.send_message(MessageBody = message,QueueUrl=queue_url,DelaySeconds=2)

def receive_message():
   return sqs.receive_message(
        QueueUrl=queue_url,
        AttributeNames=[
            'SentTimestamp'
        ],
        MaxNumberOfMessages=1,
        MessageAttributeNames=[
            'All'
        ],
        WaitTimeSeconds=20
    )    

#message = "hello 2"
#send_message(message)

message = receive_message()
print(message) 