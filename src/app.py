from flask import Flask, jsonify, request, Response
from datetime import datetime
from collections import OrderedDict
import json

app = Flask(__name__)

@app.route('/')
def get_time_and_ip():
    timestamp = datetime.utcnow().isoformat() + 'Z'
    ip_address = request.headers.get('X-Forwarded-For') or request.remote_addr

    payload = OrderedDict([
        ('timestamp', timestamp),
        ('ip', ip_address)
    ])

    return Response(
        response=json.dumps(payload),
        status=200,
        mimetype='application/json'
    )
