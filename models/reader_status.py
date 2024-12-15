from db import db


class ReaderStatusModel(db.Model):
    __tablename__ = 'ReaderStatuses'

    StatusID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    StatusName = db.Column(db.String(50), nullable=False, unique=True)
    StatusDescription = db.Column(db.String(255))

    Reader = db.relationship("ReaderModel", back_populates="ReaderStatus")
