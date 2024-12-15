from db import db


class AuthorModel(db.Model):
    __tablename__ = 'Authors'
    AuthorID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    FirstName = db.Column(db.String(50), nullable=False)
    LastName = db.Column(db.String(50), nullable=False)
