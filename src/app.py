from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def get_time_and_ip():
    timestamp = datetime.utcnow().isoformat() + 'Z'
    ip_address = request.headers.get('X-Forwarded-For') or request.remote_addr

    return jsonify({
        'timestamp': timestamp,
        'ip': ip_address
    })
