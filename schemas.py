from datetime import date

from marshmallow import Schema, fields, validate, validates, ValidationError


class GenreSchema(Schema):
    GenreID = fields.Int(dump_only=True)
    GenreName = fields.Str(required=True)
    GenreDescription = fields.Str(required=True)


class AuthorSchema(Schema):
    AuthorID = fields.Int(dump_only=True)
    FirstName = fields.Str(required=True)
    LastName = fields.Str(required=True)


class PublisherSchema(Schema):
    PublisherID = fields.Int(dump_only=True)
    PublisherName = fields.Str(required=True)
    Address = fields.Str()
    Phone = fields.Str()
    Email = fields.Str()


class CatalogSchema(Schema):
    CatalogID = fields.Int(dump_only=True)
    Shelf = fields.Str(required=True)
    Row = fields.Str(required=True)
    Section = fields.Str(required=True)


class BookSchema(Schema):
    BookID = fields.Int(dump_only=True)
    BookTitle = fields.Str(required=True, validate=validate.Length(max=255))
    PublishedYear = fields.Int(required=True)
    ISBN = fields.Str(validate=validate.Length(equal=13), required=True)
    BookEdition = fields.Str(validate=validate.Length(max=50))
    NumberOfPages = fields.Int(validate=validate.Range(min=1), required=True)
    CopiesAvailable = fields.Int(validate=validate.Range(min=0), missing=0)
    PublisherID = fields.Int(required=True)
    Publisher = fields.Nested(PublisherSchema(), dump_only=True)


class ReaderStatusSchema(Schema):
    StatusID = fields.Int(dump_only=True)
    StatusName = fields.Str(required=True)
    StatusDescription = fields.Str()


class ReaderSchema(Schema):
    ReaderID = fields.Int(dump_only=True)
    FirstName = fields.Str(required=True)
    LastName = fields.Str(required=True)
    Phone = fields.Str(validate=lambda p: len(p) <= 15 and p.isdigit())
    Email = fields.Email(required=True)
    DateOfBirth = fields.Date(format="%Y-%m-%d", required=True)
    Address = fields.Str(required=True)
    Status = fields.Int(required=True)
    StatusName = fields.Pluck(ReaderStatusSchema(), "StatusName", attribute="ReaderStatus", dump_only=True)
    CreatedAt = fields.DateTime(dump_only=True)
    UpdatedAt = fields.DateTime(dump_only=True)

    @validates("DateOfBirth")
    def validate_borrowed_date(self, value):
        if value >= date.today():
            raise ValidationError("DateOfBirth cannot be in the future.")


class BorrowingsSchema(Schema):
    BorrowingsID = fields.Int(dump_only=True)
    ReaderID = fields.Int(required=True)
    BookID = fields.Int(required=True)
    BorrowedDate = fields.Date(dump_only=True)
    DueDate = fields.Date(required=True)
    ReturnedDate = fields.Date(allow_none=True)

    @validates("BorrowedDate")
    def validate_borrowed_date(self, value):
        if value > date.today():
            raise ValidationError("BorrowedDate cannot be in the future.")

    @validates("DueDate")
    def validate_due_date(self, value):
        borrowed_date = self.context.get('BorrowedDate')
        if borrowed_date and value <= borrowed_date:
            raise ValidationError("DueDate must be after BorrowedDate.")
        if value <= date.today():
            raise ValidationError("DueDate must be in the future.")
