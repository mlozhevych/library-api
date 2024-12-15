from flask.views import MethodView
from flask_smorest import Blueprint

from db import db
from models.author import AuthorModel
from schemas import AuthorSchema

blp = Blueprint("author", __name__, url_prefix="/authors", description="Operations on authors")


@blp.route("/")
class Author(MethodView):

    @blp.response(200, AuthorSchema(many=True))
    def get(self):
        """List all authors"""
        return AuthorModel.query.all()

    @blp.arguments(AuthorSchema)
    @blp.response(201, AuthorSchema)
    def post(self, author_data):
        """Add a new author"""
        # Validate input data before creating the Publisher instance
        schema = AuthorSchema()
        schema.validate(author_data)
        author = AuthorModel(**author_data)
        db.session.add(author)
        db.session.commit()
        return author
