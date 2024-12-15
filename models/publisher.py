from db import db


class PublisherModel(db.Model):
    __tablename__ = 'Publishers'

    PublisherID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    PublisherName = db.Column(db.String(100), nullable=False, unique=True)
    Address = db.Column(db.String(255))
    Phone = db.Column(db.String(15))
    Email = db.Column(db.String(100))

    Book = db.relationship("BookModel", back_populates="Publisher")
