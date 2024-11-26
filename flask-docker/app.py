from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '{"message: "Hello, world!"}'


if __name__ == "__main__":
    app.run(ssl_context=('cert.pem', 'key.pem'), host='0.0.0.0', debug=True)