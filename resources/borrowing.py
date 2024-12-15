from flask.views import MethodView
from flask_smorest import Blueprint, abort
from sqlalchemy.sql.functions import current_date

from db import db
from models.book import BookModel
from models.borrowing import BorrowingModel
from models.reader import ReaderModel
from schemas import BorrowingsSchema

blp = Blueprint('borrowings', __name__, url_prefix='/borrowings', description='Operations on Borrowings')


@blp.route("/<string:borrowing_id>")
class Borrowing(MethodView):
    @blp.response(200, BorrowingsSchema)
    def get(self, borrowing_id):
        """Get a borrowing by ID"""
        borrowing = BorrowingModel.query.get_or_404(borrowing_id)
        return borrowing

    @blp.arguments(BorrowingsSchema)
    @blp.response(200, BorrowingsSchema)
    def put(self, update_data, borrowing_id):
        """Update a borrowing by ID"""
        borrowing = BorrowingModel.query.get_or_404(borrowing_id)
        for key, value in update_data.items():
            setattr(borrowing, key, value)
        db.session.commit()
        return borrowing


@blp.route("/")
class BorrowingList(MethodView):
    @blp.response(200, BorrowingsSchema(many=True))
    def get(self):
        """List all borrowings"""
        borrowings = BorrowingModel.query.all()
        return borrowings

    @blp.arguments(BorrowingsSchema)
    @blp.response(201, BorrowingsSchema)
    def post(self, new_data):
        """Create a new borrowing record"""
        # Check if the Reader exists
        reader = ReaderModel.query.get(new_data['ReaderID'])
        if not reader:
            abort(404, message="Reader with the given ID does not exist")
        if reader.ReaderStatus.StatusName != "Active":
            abort(404, message="Reader is not Active and cannot borrow books")

        # Check if the Book exists
        book = BookModel.query.get(new_data['BookID'])
        if not book:
            abort(404, message="Book with the given ID does not exist")
        if book.CopiesAvailable < 1:
            abort(404, message="Book is out of stock")
        # Change the number of copies
        book.CopiesAvailable -= 1

        new_data["BorrowedDate"] = current_date()
        borrowing = BorrowingModel(**new_data)
        db.session.add(borrowing)
        db.session.commit()
        return borrowing
