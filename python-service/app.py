from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello')
def hello():
    return jsonify(message="Hello from Python Service!"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1723)
