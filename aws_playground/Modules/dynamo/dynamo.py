import boto3
import botostubs

 
dynamodb:botostubs.DynamoDB.DynamodbResource = boto3.resource('dynamodb')

  
def write_batch(table_name, batch):  
    table = dynamodb.Table(table_name)
    with table.batch_writer() as batch_writer:
        for item in batch:
            batch_writer.put_item(
                Item=item 
            )
 

raceData = [
  {
    'id': 1,
    'name': 'Zepto',
    'type': 'Speedball', 
    'results': []
  },
  {
    'id': 2,
    'name': 'Jassi',
    'type': 'Speedball', 
    'results': []
  } 
] 

write_batch('races',raceData)