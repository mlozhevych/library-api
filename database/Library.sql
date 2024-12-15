CREATE DATABASE IF NOT EXISTS Library;

-- Borrowings Table
DROP TABLE IF EXISTS `Library`.`Borrowings`;

CREATE TABLE `Library`.`Borrowings` (
    `BorrowingsID` INT AUTO_INCREMENT PRIMARY KEY,
    `ReaderID` INT NOT NULL,
    `BookID` INT NOT NULL,
    `BorrowedDate` DATE NOT NULL,
    `DueDate` DATE NOT NULL,
    `ReturnedDate` DATE NULL
);

-- BookCatalog Table
DROP TABLE IF EXISTS `Library`.`BookCatalog`;

CREATE TABLE `Library`.`BookCatalog` (
    `BookCatalogID` INT AUTO_INCREMENT PRIMARY KEY,
    `BookID` INT NOT NULL,
    `CatalogID` INT NOT NULL
);

-- BookAuthors Table
DROP TABLE IF EXISTS `Library`.`BookAuthors`;

CREATE TABLE `Library`.`BookAuthors` (
    `BookAuthorsID` INT AUTO_INCREMENT PRIMARY KEY,
    `BookID` INT NOT NULL,
    `AuthorID` INT NOT NULL
);

-- BookGenres Table
DROP TABLE IF EXISTS `Library`.`BookGenres`;

CREATE TABLE `Library`.`BookGenres` (
    `BookGenresID` INT AUTO_INCREMENT PRIMARY KEY,
    `BookID` INT NOT NULL,
    `GenreID` INT NOT NULL
);

-- Readers Table
DROP TABLE IF EXISTS `Library`.`Readers`;

CREATE TABLE `Library`.`Readers` (
    `ReaderID` INT AUTO_INCREMENT PRIMARY KEY,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Phone` CHAR(15), -- Припускається формат телефону до 15 символів
    `Email` VARCHAR(100) UNIQUE,
    `DateOfBirth` DATE,
    `Address` VARCHAR(255),
    `Status` INT NOT NULL,
    `CreatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `UpdatedAt` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Reader Statuses Table
DROP TABLE IF EXISTS `Library`.`ReaderStatuses`;

CREATE TABLE `Library`.`ReaderStatuses` (
    `StatusID` INT AUTO_INCREMENT PRIMARY KEY,
    `StatusName` VARCHAR(50) NOT NULL UNIQUE,
    `StatusDescription` VARCHAR(255)
);

-- Books Table
DROP TABLE IF EXISTS `Library`.`Books`;

CREATE TABLE `Library`.`Books` (
    `BookID` INT AUTO_INCREMENT PRIMARY KEY,
    `BookTitle` VARCHAR(255) NOT NULL,
    `PublishedYear` INT,
    `ISBN` CHAR(13) UNIQUE, -- Стандартизований ISBN-13
    `BookEdition` VARCHAR(50),
    `NumberOfPages` INT CHECK (`NumberOfPages` > 0),
    `CopiesAvailable` INT DEFAULT 0,
    `PublisherID` INT NOT NULL
);

-- Publishers Table
DROP TABLE IF EXISTS `Library`.`Publishers`;

CREATE TABLE `Library`.`Publishers` (
    `PublisherID` INT AUTO_INCREMENT PRIMARY KEY,
    `PublisherName` VARCHAR(100) NOT NULL UNIQUE,
    `Address` VARCHAR(255),
    `Phone` CHAR(15), -- Припускається формат телефону до 15 символів
    `Email` VARCHAR(100)
);

-- Genres Table
DROP TABLE IF EXISTS `Library`.`Genres`;

CREATE TABLE `Library`.`Genres` (
    `GenreID` INT AUTO_INCREMENT PRIMARY KEY,
    `GenreName` VARCHAR(50) NOT NULL UNIQUE,
    `GenreDescription` VARCHAR(255)
);

-- Authors Table
DROP TABLE IF EXISTS `Library`.`Authors`;

CREATE TABLE `Library`.`Authors` (
    `AuthorID` INT AUTO_INCREMENT PRIMARY KEY,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL
);

-- Catalog Table
DROP TABLE IF EXISTS `Library`.`Catalog`;

CREATE TABLE `Library`.`Catalog` (
    `CatalogID` INT AUTO_INCREMENT PRIMARY KEY,
    `Shelf` VARCHAR(50),
    `Row` VARCHAR(50),
    `Section` VARCHAR(50)
);


-- Create Foreign Key Constraint for Readers.Status
ALTER TABLE `Library`.`Readers`
ADD CONSTRAINT `FK_ReaderStatus` FOREIGN KEY (`Status`) REFERENCES `Library`.`ReaderStatuses`(`StatusID`);

-- Create Foreign Key Constraint for Books.PublisherID
ALTER TABLE `Library`.`Books`
ADD CONSTRAINT `FK_BookPublisher` FOREIGN KEY (`PublisherID`) REFERENCES `Library`.`Publishers`(`PublisherID`);

-- Create Foreign Key Constraint for BookGenres.BookID AND BookGenres.GenreID
ALTER TABLE `Library`.`BookGenres`
ADD CONSTRAINT `FK_BookGenresBookID` FOREIGN KEY (`BookID`) REFERENCES `Library`.`Books`(`BookID`),
ADD CONSTRAINT `FK_BookGenresGenreID` FOREIGN KEY (`GenreID`) REFERENCES `Library`.`Genres`(`GenreID`);

-- Create Foreign Key Constraint for BookAuthors.BookID AND BookAuthors.AuthorID
ALTER TABLE `Library`.`BookAuthors`
ADD CONSTRAINT `FK_BookAuthorsBookID` FOREIGN KEY (`BookID`) REFERENCES `Library`.`Books`(`BookID`),
ADD CONSTRAINT `FK_BookAuthorsAuthorID` FOREIGN KEY (`AuthorID`) REFERENCES `Library`.`Authors`(`AuthorID`);

-- Create Foreign Key Constraint for BookCatalog.BookID AND BookCatalog.CatalogID
ALTER TABLE `Library`.`BookCatalog`
ADD CONSTRAINT `FK_BookCatalogBookID` FOREIGN KEY (`BookID`) REFERENCES `Library`.`Books`(`BookID`),
ADD CONSTRAINT `FK_BookCatalogCatalogID` FOREIGN KEY (`CatalogID`) REFERENCES `Library`.`Catalog`(`CatalogID`);

-- Create Foreign Key Constraint for Borrowings.BookID AND Borrowings.ReaderID
ALTER TABLE `Library`.`Borrowings`
ADD CONSTRAINT `FK_BorrowingsReaderID` FOREIGN KEY (`ReaderID`) REFERENCES `Library`.`Readers`(`ReaderID`),
ADD CONSTRAINT `FK_BorrowingsBookID` FOREIGN KEY (`BookID`) REFERENCES `Library`.`Books`(`BookID`);

-- Test data for ReaderStatuses Table
INSERT INTO `Library`.`ReaderStatuses` (StatusName, StatusDescription)
VALUES 
    ('Active', 'Currently an active reader'),
    ('Inactive', 'No longer borrowing books'),
    ('Blocked', 'Temporarily blocked from borrowing');

-- Test data for Readers Table
INSERT INTO `Library`.`Readers` (FirstName, LastName, Phone, Email, DateOfBirth, `Address`, `Status`)
VALUES    
    ('John', 'Doe', '1234567890', 'john.doe@gmail.com', '1990-01-15', '123 Main St, Cityville', 1),
    ('Jane', 'Smith', '0987654321', 'jane.smith@hotmail.com', '1985-06-20', '456 Elm St, Townsville', 1),
    ('Alice', 'Brown', '5678901234', 'alice.brown@gmail.com', '2000-11-05', '789 Oak St, Villagetown', 2),
    ('Bob', 'Johnson', '7890123456', 'bob.johnson@yahoo.com', '1995-03-12', '321 Pine St, CapitalCity', 3),
    ('Carol', 'White', '3456789012', 'carol.white@outlook.com', '1998-07-22', '654 Maple St, Downtown', 1),
    ('Eve', 'Davis', '8765432109', 'eve.davis@gmail.com', '1983-02-19', '987 Birch St, Uptown', 2),
    ('Frank', 'Miller', '2345678901', 'frank.miller@hotmail.com', '1975-10-31', '111 Cedar St, Suburbia', 3),
    ('Grace', 'Wilson', '4567890123', 'grace.wilson@aol.com', '2002-12-25', '222 Walnut St, MetroCity', 1),
    ('Hank', 'Taylor', '1230984567', 'hank.taylor@gmail.com', '1987-04-09', '333 Poplar St, RiverTown', 2),
    ('Ivy', 'Anderson', '3216549870', 'ivy.anderson@yahoo.com', '1993-08-16', '444 Cherry St, LakeView', 3);

-- Test data for Publishers Table
INSERT INTO `Library`.`Publishers` (PublisherName, `Address`, Phone, Email)
VALUES
    ('Penguin Books', '123 Publisher Ln, BookCity', '1112223333', 'contact@penguinbooks.com'),
    ('HarperCollins', '456 Publishing St, LitTown', '2223334444', 'info@harpercollins.com'),
    ('Random House', '789 Edit Ave, NovelVille', '3334445555', 'support@randomhouse.com'),
    ('Vintage Classics', '101 Literature Way, NovelTown', '4445556666', 'contact@vintageclassics.com'),
    ('Macmillan', '202 Story Ave, PrintCity', '5556667777', 'info@macmillan.com');

-- Test data for Books Table
INSERT INTO `Library`.`Books` (BookTitle, PublishedYear, ISBN, BookEdition, NumberOfPages, CopiesAvailable, PublisherID)
VALUES
    ('The Great Gatsby', 1925, '9780141182636', 'First', 218, 5, 1),
    ('1984', 1949, '9780451524935', 'Second', 328, 8, 2),
    ('To Kill a Mockingbird', 1960, '9780061120084', 'Third', 281, 3, 3),
    ('Brave New World', 1932, '9780060850524', 'First', 268, 7, 1),
    ('Animal Farm', 1945, '9780451526342', 'Fourth', 112, 6, 2),
    ('The Catcher in the Rye', 1951, '9780316769488', 'First', 214, 4, 3),
    ('Pride and Prejudice', 1813, '9780141439518', 'Third', 279, 2, 2),
    ('Moby Dick', 1851, '9781503280786', 'Second', 635, 3, 2),
    ('War and Peace', 1869, '9780199232765', 'First', 1225, 5, 2),
    ('The Hobbit', 1937, '9780547928227', 'Fifth', 310, 10, 3);

-- Test data for Genres Table
-- Test data for Genres Table
INSERT INTO `Library`.`Genres` (`GenreName`, `GenreDescription`)
VALUES
    ('Fiction', 'A literary genre that includes imaginative or invented stories.'),
    ('Classics', 'Timeless literature that has stood the test of time.'),
    ('Drama', 'A genre of narrative fiction that focuses on emotional and relational development.'),
    ('Science Fiction', 'Stories often involving futuristic technology or space exploration.'),
    ('Fantasy', 'Literature that includes magical or supernatural elements.'),
    ('Mystery', 'Fictional works focusing on solving crimes or unraveling secrets.'),
    ('Romance', 'Stories that focus on relationships and romantic love.'),
    ('Thriller', 'A genre characterized by excitement and suspense.'),
    ('Adventure', 'Literature involving exciting journeys and discoveries.'),
    ('Historical Fiction', 'Stories set in a specific historical period with fictionalized events.'),
    ('Horror', 'Literature intended to evoke fear, shock, or disgust.'),
    ('Biography', 'The life story of a person written by someone else.'),
    ('Self-Help', 'Books designed to help readers solve personal problems.'),
    ('Philosophy', 'Works exploring fundamental questions about life and existence.'),
    ('Poetry', 'A literary form emphasizing expression, rhythm, and imagery.');

-- Test data for BookGenres Table
INSERT INTO `Library`.`BookGenres` (BookID, GenreID)
VALUES
    (1, 1), -- The Great Gatsby (Fiction)
    (1, 2), -- The Great Gatsby (Classics)
    (2, 1), -- 1984 (Fiction)
    (2, 4), -- 1984 (Science Fiction)
    (3, 1), -- To Kill a Mockingbird (Fiction)
    (3, 2), -- To Kill a Mockingbird (Classics)
    (3, 3), -- To Kill a Mockingbird (Drama)
    (4, 1), -- Brave New World (Fiction)
    (4, 4), -- Brave New World (Science Fiction)
    (5, 1), -- Animal Farm (Fiction)
    (5, 4), -- Animal Farm (Science Fiction)
    (6, 1), -- The Catcher in the Rye (Fiction)
    (6, 2), -- The Catcher in the Rye (Classics)
    (6, 3), -- The Catcher in the Rye (Drama)
    (7, 2), -- Pride and Prejudice (Classics)
    (7, 7), -- Pride and Prejudice (Romance)
    (8, 1), -- Moby Dick (Fiction)
    (8, 2), -- Moby Dick (Classics)
    (8, 10), -- Moby Dick (Historical Fiction)
    (9, 2), -- War and Peace (Classics)
    (9, 10), -- War and Peace (Historical Fiction)
    (10, 1), -- The Hobbit (Fiction)
    (10, 5); -- The Hobbit (Fantasy)

-- Test data for Authors Table
INSERT INTO `Library`.`Authors` (FirstName, LastName)
VALUES
    ('F. Scott', 'Fitzgerald'), -- Автор "The Great Gatsby"
    ('George', 'Orwell'), -- Автор "1984" та "Animal Farm"
    ('Harper', 'Lee'), -- Автор "To Kill a Mockingbird"
    ('Aldous', 'Huxley'), -- Автор "Brave New World"
    ('J.D.', 'Salinger'), -- Автор "The Catcher in the Rye"
    ('Jane', 'Austen'), -- Автор "Pride and Prejudice"
    ('Herman', 'Melville'), -- Автор "Moby Dick"
    ('Leo', 'Tolstoy'), -- Автор "War and Peace"
    ('J.R.R.', 'Tolkien'); -- Автор "The Hobbit"

-- Test data for BookAuthors Table
INSERT INTO `Library`.`BookAuthors` (BookID, AuthorID)
VALUES
    (1, 1), -- The Great Gatsby by F. Scott Fitzgerald
    (2, 2), -- 1984 by George Orwell
    (3, 3), -- To Kill a Mockingbird by Harper Lee
    (4, 4), -- Brave New World by Aldous Huxley
    (5, 2), -- Animal Farm by George Orwell
    (6, 5), -- The Catcher in the Rye by J.D. Salinger
    (7, 6), -- Pride and Prejudice by Jane Austen
    (8, 7), -- Moby Dick by Herman Melville
    (9, 8), -- War and Peace by Leo Tolstoy
    (10, 9); -- The Hobbit by J.R.R. Tolkien

-- Test data for Catalog Table
INSERT INTO `Library`.`Catalog` (Shelf, `Row`, Section)
VALUES
     ('A', '1', 'Fiction'),
    ('A', '2', 'Science Fiction'),
    ('A', '3', 'Fantasy'),
    ('B', '1', 'Classics'),
    ('B', '2', 'Biography'),
    ('B', '3', 'History'),
    ('C', '1', 'Drama'),
    ('C', '2', 'Poetry'),
    ('C', '3', 'Mystery'),
    ('D', '1', 'Romance'),
    ('D', '2', 'Thriller'),
    ('D', '3', 'Adventure'),
    ('E', '1', 'Science'),
    ('E', '2', 'Mathematics'),
    ('E', '3', 'Philosophy'),
    ('F', '1', 'Psychology'),
    ('F', '2', 'Self-Help'),
    ('F', '3', 'Religion'),
    ('G', '1', 'Art'),
    ('G', '2', 'Photography'),
    ('G', '3', 'Cooking'),
    ('H', '1', 'Travel'),
    ('H', '2', 'True Crime'),
    ('H', '3', 'Sports');

-- Test data for BookCatalog Table
INSERT INTO `Library`.`BookCatalog` (BookID, CatalogID)
VALUES
    (1, 1), -- The Great Gatsby in Fiction section
    (2, 2), -- 1984 in Classics section
    (3, 3), -- To Kill a Mockingbird in Drama section
    (4, 1), -- Brave New World in Fiction section
    (5, 2), -- Animal Farm in Classics section
    (6, 3), -- The Catcher in the Rye in Drama section
    (7, 2), -- Pride and Prejudice in Classics section
    (8, 3), -- Moby Dick in Drama section
    (9, 2), -- War and Peace in Classics section
    (10, 1); -- The Hobbit in Fiction section

-- Test data for Borrowings Table
INSERT INTO `Library`.`Borrowings` (ReaderID, BookID, BorrowedDate, DueDate, ReturnedDate)
VALUES
    (1, 1, '2024-11-01', '2024-11-15', NULL), -- John borrowed The Great Gatsby
    (2, 2, '2024-11-05', '2024-11-20', '2024-11-18'), -- Jane borrowed and returned 1984
    (3, 3, '2024-11-10', '2024-11-25', NULL), -- Alice borrowed To Kill a Mockingbird
    (4, 4, '2024-11-12', '2024-11-22', NULL), -- Bob borrowed Brave New World
    (5, 5, '2024-11-15', '2024-11-30', '2024-11-28'), -- Carol borrowed and returned Animal Farm
    (6, 6, '2024-11-18', '2024-12-02', NULL), -- Eve borrowed The Catcher in the Rye
    (7, 7, '2024-11-20', '2024-12-05', NULL), -- Frank borrowed Pride and Prejudice
    (8, 8, '2024-11-22', '2024-12-07', '2024-12-01'), -- Grace borrowed and returned Moby Dick
    (9, 9, '2024-11-25', '2024-12-10', NULL), -- Hank borrowed War and Peace
    (10, 10, '2024-11-28', '2024-12-12', NULL); -- Ivy borrowed The Hobbit	

