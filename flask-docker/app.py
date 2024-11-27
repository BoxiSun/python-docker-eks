from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '{"message: "Hello, world, test by Boxi, again!"}'


if __name__ == "__main__":
    app.run(host='0.0.0.0')