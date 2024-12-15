from resources.author import blp as AuthorBlueprint
from resources.book import blp as BookBlueprint
from resources.borrowing import blp as BorrowingBlueprint
from resources.borrowing import blp as BorrowingBlueprint
from resources.catalog import blp as CatalogBlueprint
from resources.genre import blp as GenreBlueprint
from resources.publisher import blp as PublisherBlueprint
from resources.reader import blp as ReaderBlueprint
from resources.reader_status import blp as ReaderStatusBlueprint

__all__ = ["BookBlueprint", "ReaderBlueprint", "BorrowingBlueprint", "GenreBlueprint", "PublisherBlueprint",
           "CatalogBlueprint", "AuthorBlueprint", "ReaderBlueprint", "ReaderStatusBlueprint", "BorrowingBlueprint"]
