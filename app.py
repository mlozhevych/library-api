import inspect
import os

from dotenv import load_dotenv
from flask import Flask, request
from flask_smorest import Api, Blueprint

from db import db
from resources import blueprints

server = Flask(__name__)
load_dotenv()

DATABASE_USER = os.getenv('DATABASE_USER')
DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD')
DATABASE_HOST = os.getenv('DATABASE_HOST')
DATABASE_DB = os.getenv('DATABASE_DB')

server.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_HOST}/{DATABASE_DB}"
server.config["API_TITLE"] = "REST API for library management"
server.config["API_VERSION"] = "v1"
server.config["OPENAPI_VERSION"] = "3.0.3"
server.config["OPENAPI_URL_PREFIX"] = "/"
server.config["OPENAPI_SWAGGER_UI_PATH"] = "/swagger-ui"
server.config["OPENAPI_SWAGGER_UI_URL"] = "https://cdn.jsdelivr.net/npm/swagger-ui-dist/"
server.config['DEBUG'] = True

# db = SQLAlchemy(server)
db.init_app(server)
api = Api(server)


@server.before_request
def log_request_data():
    print("Headers:", request.headers)
    print("Body:", request.get_data(as_text=True))
    print("Content-Type:", request.content_type)
    print("JSON:", request.get_json(silent=True))


with server.app_context():
    db.create_all()

library = Blueprint("library", "library", url_prefix="/library", description="Library REST API")

blueprints_list = [
    bp for name, bp in inspect.getmembers(blueprints)
    if isinstance(bp, Blueprint)
]

for bp in blueprints_list:
    library.register_blueprint(bp)

api.register_blueprint(library)

if __name__ == "__main__":
    server.run(host="0.0.0.0", port=5000)
