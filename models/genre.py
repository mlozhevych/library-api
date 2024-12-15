from db import db


class GenreModel(db.Model):
    __tablename__ = 'Genres'
    GenreID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    GenreName = db.Column(db.String(50), nullable=False, unique=True)
    GenreDescription = db.Column(db.String(255))
