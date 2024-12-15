from flask.views import MethodView
from flask_smorest import Blueprint

from models.reader_status import ReaderStatusModel
from schemas import ReaderStatusSchema

blp = Blueprint('reader_statuses', __name__, url_prefix="/reader-statuses", description="Operations on reader statuses")

@blp.route('/')
class ReaderStatusList(MethodView):
    @blp.response(200, ReaderStatusSchema(many=True))
    def get(self):
        """List all reader statuses"""
        statuses = ReaderStatusModel.query.all()
        return statuses