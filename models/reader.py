from db import db


class ReaderModel(db.Model):
    __tablename__ = 'Readers'

    ReaderID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    FirstName = db.Column(db.String(50), nullable=False)
    LastName = db.Column(db.String(50), nullable=False)
    Phone = db.Column(db.String(15), nullable=True)
    Email = db.Column(db.String(100), unique=True)
    DateOfBirth = db.Column(db.Date, nullable=False)
    Address = db.Column(db.String(255))
    Status = db.Column(db.Integer, db.ForeignKey('ReaderStatuses.StatusID'), nullable=False)
    CreatedAt = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    UpdatedAt = db.Column(db.DateTime, server_default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    ReaderStatus = db.relationship("ReaderStatusModel", back_populates="Reader")
