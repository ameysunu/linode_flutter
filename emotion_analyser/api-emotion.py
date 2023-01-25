from flask import Flask, request
import json_tricks as json
import cv2
from fer import FER
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import urllib.request
import random

app = Flask(__name__)

@app.route('/detect_emotions', methods=['GET'])
def detect_emotions():
    url_address = request.args.get('url_address')
    headers={'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}
    request_=urllib.request.Request(url_address,None,headers) #The assembled request
    response = urllib.request.urlopen(request_)# store the response

    filename = random.randint(1000, 1000000)
    #create a new file and write the image
    f= open(f'{filename}.jpg', 'wb')
    f.write(response.read())
    f.close()

    # Input Image
    input_image = cv2.imread(f"{filename}.jpg") 
    emotion_detector = FER()
    # Output image's information
    emotions_detected = emotion_detector.detect_emotions(input_image)
    emotions_detected = json.dumps(emotions_detected)
    detector = FER(mtcnn=True)
    emotions_detected2 = detector.detect_emotions(input_image)
    emotions_detected2 = json.dumps(emotions_detected2)
    emotion, score = detector.top_emotion(input_image)
    return {'emotions_detected1':emotions_detected,'emotions_detected2':emotions_detected2,'top_emotion':emotion,'top_emotion_score':score}

if __name__ == '__main__':
    app.run(debug=True, port=8000)

