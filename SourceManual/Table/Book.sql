CREATE TABLE SourceManual.Book
(
	BookNumber      INT NOT NULL,
	BookShortName	NVARCHAR(100) NOT NULL,
	BookName		NVARCHAR(100) NOT NULL,
	BookDefaultSort  INT NOT NULL,
	BookLanguageName NVARCHAR(100) NOT NULL,
	BookGroupName    NVARCHAR(100) NOT NULL,
	BookGroupSort    INT NOT NULL,
	BookSubGroupName NVARCHAR(100) NOT NULL,
	BookSubGroupSort INT NOT NULL,
	BookTraditionalSort INT NOT NULL
)
GO

ALTER TABLE SourceManual.Book
ADD CONSTRAINT Book_PK
PRIMARY KEY
(
BookNumber 
)
GO

ALTER TABLE SourceManual.Book
ADD CONSTRAINT Book_AK1
UNIQUE
(
BookShortName
)
GO

ALTER TABLE SourceManual.Book
ADD CONSTRAINT Book_AK2
UNIQUE
(
BookName
)
GO

ALTER TABLE SourceManual.Book
ADD CONSTRAINT Book_AK3
UNIQUE
(
BookDefaultSort
)
GO

ALTER TABLE SourceManual.Book
ADD CONSTRAINT Book_AK4
UNIQUE
(
BookTraditionalSort
)
GO