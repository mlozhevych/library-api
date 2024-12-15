from flask.views import MethodView
from flask_smorest import Blueprint, abort

from db import db
from models.publisher import PublisherModel
from schemas import PublisherSchema

blp = Blueprint("publisher", __name__, url_prefix="/publishers", description="Operations on publishers")


@blp.route("/")
class Publisher(MethodView):
    @blp.response(200, PublisherSchema(many=True))
    def get(self):
        """Get all publishers"""
        return PublisherModel.query.all()

    @blp.arguments(PublisherSchema)
    @blp.response(201, PublisherSchema)
    def post(self, new_data):
        """Create a new publisher"""
        # Validate input data before creating the Publisher instance
        schema = PublisherSchema()
        schema.validate(new_data)
        publisher_name = PublisherModel.query.filter_by(PublisherName=new_data["PublisherName"]).first()
        if publisher_name:
            abort(400, message="Publisher with such a name already exists")

        publisher = PublisherModel(**new_data)
        db.session.add(publisher)
        db.session.commit()
        return publisher
