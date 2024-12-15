from db import db


class BookModel(db.Model):
    __tablename__ = 'Books'

    BookID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    BookTitle = db.Column(db.String(255), nullable=False)
    PublishedYear = db.Column(db.Integer, nullable=False)
    ISBN = db.Column(db.String(13), nullable=False, unique=True)
    BookEdition = db.Column(db.String(50), nullable=False)
    NumberOfPages = db.Column(db.Integer, nullable=False)
    CopiesAvailable = db.Column(db.Integer, default=0)
    PublisherID = db.Column(db.Integer, db.ForeignKey('Publishers.PublisherID'), nullable=False)

    Publisher = db.relationship("PublisherModel", back_populates="Book")
