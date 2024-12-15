from db import db


class BorrowingModel(db.Model):
    __tablename__ = 'Borrowings'
    BorrowingsID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ReaderID = db.Column(db.Integer, db.ForeignKey('Readers.ReaderID'), nullable=False)
    BookID = db.Column(db.Integer, db.ForeignKey('Books.BookID'), nullable=False)
    BorrowedDate = db.Column(db.Date, nullable=False)
    DueDate = db.Column(db.Date, nullable=False)
    ReturnedDate = db.Column(db.Date, nullable=True)
