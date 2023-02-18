from flask import Flask, jsonify
from dotenv import load_dotenv
import os

load_dotenv('spotifyapi.env')

app = Flask(__name__)

@app.route('/api/env_variables/<name>')
def get_env_variable(name):
    value = os.environ.get(name)
    if value is not None:
        return jsonify({"name": name, "value": value})
    else:
        return jsonify({"error": f"Environment variable {name} not found"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6969)