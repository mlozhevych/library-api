from flask.views import MethodView
from flask_smorest import Blueprint, abort

from db import db
from models.book import BookModel
from schemas import BookSchema

blp = Blueprint("book", __name__, url_prefix="/books", description="Operations on books")


@blp.route("/<int:book_id>")
class Book(MethodView):
    @blp.response(200, BookSchema)
    def get(self, book_id):
        """Retrieve a book by ID"""
        book = BookModel.query.get_or_404(book_id)
        return book

    @blp.arguments(BookSchema(partial=True))
    @blp.response(200, BookSchema)
    def patch(self, update_data, book_id):
        """Partially update a book by ID"""
        book = BookModel.query.get_or_404(book_id)
        for key, value in update_data.items():
            setattr(book, key, value)
        db.session.commit()
        return book

    @blp.response(204)
    def delete(self, book_id):
        """Delete a book by ID"""
        book = BookModel.query.get_or_404(book_id)
        db.session.delete(book)
        db.session.commit()
        return None


@blp.route("/")
class BookList(MethodView):
    @blp.response(200, BookSchema(many=True))
    def get(self):
        """Retrieve all books"""
        return BookModel.query.all()

    @blp.arguments(BookSchema)
    @blp.response(201, BookSchema)
    def post(self, new_data):
        """Add a new book"""
        isbn = new_data.get("ISBN")
        book = BookModel.query.filter_by(ISBN=isbn).first()
        if book:
            abort(400, message="Book with the given ISBN already exist")

        sanitized_data = {key: new_data[key] for key in BookSchema().fields if key in new_data}
        book = BookModel(**sanitized_data)
        db.session.add(book)
        db.session.commit()
        return book
