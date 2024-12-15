from flask.views import MethodView
from flask_smorest import Blueprint, abort
from marshmallow import ValidationError

from db import db
from models.reader import ReaderModel
from models.reader_status import ReaderStatusModel
from schemas import ReaderSchema

blp = Blueprint("reader", __name__, url_prefix="/readers", description="Reader Operations")


@blp.route("/<string:reader_id>")
class Reader(MethodView):
    @blp.response(200, ReaderSchema)
    def get(self, reader_id):
        """Get reader by ID"""
        reader = ReaderModel.query.get_or_404(reader_id)
        print(reader.ReaderStatus.StatusName)
        return reader

    @blp.response(204)
    def delete(self, reader_id):
        """Delete reader by ID"""
        reader = ReaderModel.query.get_or_404(reader_id)
        db.session.delete(reader)
        db.session.commit()
        return '', 204


@blp.route("/")
class ReaderList(MethodView):
    @blp.response(200, ReaderSchema(many=True))
    def get(self):
        """List all readers"""
        return ReaderModel.query.all()

    @blp.arguments(ReaderSchema)
    @blp.response(201, ReaderSchema)
    def post(self, new_data):
        """Create a new reader"""
        print(new_data)
        try:
            # Validate input data before creating the Reader instance
            schema = ReaderSchema()
            schema.validate(new_data)

            reader_email = ReaderModel.query.filter_by(Email=new_data["Email"]).first()
            if reader_email:
                abort(400, message="Email already exist")

            reader_status = ReaderStatusModel.query.get(new_data["Status"])
            if not reader_status:
                abort(400, message="Status does not exist")

            reader = ReaderModel(**new_data)
            db.session.add(reader)
            db.session.commit()
            return reader
        except ValidationError as err:
            abort(400, message=err.messages)
