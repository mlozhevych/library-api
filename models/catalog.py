from db import db


class CatalogModel(db.Model):
    __tablename__ = 'Catalog'

    CatalogID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Shelf = db.Column(db.String(50), nullable=False)
    Row = db.Column(db.String(50), nullable=False)
    Section = db.Column(db.String(50), nullable=False)