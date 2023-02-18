import os
import schedule
import time
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from dotenv import load_dotenv, set_key

load_dotenv('spotifyapi.env')

client_id = "CLIENT_ID"
client_secret = "CLIENT_SECRET"


def set_key(file_path, key, value):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        updated = False
        for line in lines:
            if line.startswith(f"{key}="):
                file.write(f"{key}={value}\n")
                print('done')
                updated = True
            else:
                file.write(line)
        if not updated:
            file.write(f"{key}={value}\n")

def generate_token():
    client_credentials_manager = SpotifyClientCredentials(
        client_id=client_id, client_secret=client_secret)
    sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
    token = client_credentials_manager.get_access_token()
    print(token['access_token'])
    set_key('spotifyapi.env', 'SPOTIFY_API_KEY', token['access_token']) 
    print("Token generated and .env file updated.")

schedule.every(45).minutes.do(generate_token)

while True:
    schedule.run_pending()
    time.sleep(1)
                                                                                                                                                                                                       