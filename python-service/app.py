from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify(message="Hi Iouring Team"), 200

@app.route('/app')
def hello_app():
    return jsonify(message="Hi Iouring Team from app"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
