from flask.views import MethodView
from flask_smorest import Blueprint

from models.genre import GenreModel
from schemas import GenreSchema

blp = Blueprint("genre", __name__, url_prefix="/genres", description="Operations on genres")


@blp.route("/")
class Genre(MethodView):
    @blp.response(200, GenreSchema(many=True))
    def get(self):
        """List all genre"""
        return GenreModel.query.all()
