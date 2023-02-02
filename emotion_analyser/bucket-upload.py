from flask import Flask, request
import boto3
import json
import random
import requests

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
    filename = random.randint(1000, 1000000)
    response = client.put_object(
        Bucket='dev-hackathon',
        Key=f'{filename}.jpg',
        Body=file.read(),
        ACL='public-read'
    )
    print('Calling emotion analysis API')

    url = f'http://localhost:8000/detect_emotions?url_address=https://dev-hackathon.eu-central-1.linodeobjects.com/{filename}.jpg'
    new_response = requests.get(url)
    return json.dumps(new_response.text)


if __name__ == '__main__':
    app.run()
