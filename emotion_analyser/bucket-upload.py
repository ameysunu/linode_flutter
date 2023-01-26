from flask import Flask, request
import boto3
import json

app = Flask(__name__)

AWS_S3_ENDPOINT_URL = 'https://eu-central-1.linodeobjects.com'
client = boto3.client(
    's3',
    region_name='eu-central-1', #Change Region Name accordingly
    endpoint_url=AWS_S3_ENDPOINT_URL,
    aws_access_key_id='ACCESS_KEY',
    aws_secret_access_key='SECRET_ACCESS_KEYS'
)

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['image']
    response = client.put_object(
        Bucket='BUCKET_NAME',
        Key='random.jpg',
        Body=file.read()
    )
    return json.dumps(response)

if __name__ == '__main__':
    app.run()
