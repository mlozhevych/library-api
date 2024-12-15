from flask.views import MethodView
from flask_smorest import Blueprint

from models.catalog import CatalogModel
from schemas import CatalogSchema

blp = Blueprint('catalog', __name__, url_prefix='/catalog', description="Operations on catalog")


@blp.route('/')
class Catalog(MethodView):
    @blp.response(200, CatalogSchema(many=True))
    def get(self):
        """Get all catalog entries"""
        return CatalogModel.query.all()
