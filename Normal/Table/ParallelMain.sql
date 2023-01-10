CREATE TABLE Normal.ParallelMain
(
	BookNumber	    INT NOT NULL,
	ChapterNumber   INT NOT NULL,
	VerseNumber		INT NOT NULL,
	VerseId         INT NOT NULL,
	WordNumber		INT NOT NULL,
	WordGlobalDefaultSort  INT NOT NULL,
	WordGlobalTraditionalSort  INT NOT NULL,
	WordElementId   INT NOT NULL,
	OriginalId      INT NOT NULL,
	OriginalText    NVARCHAR(200),
	TransliterationId    INT NOT NULL,
	TransliterationText  NVARCHAR(200),
	EnglishText      NVARCHAR(200) NOT NULL,
	MorphologyId     INT NOT NULL
)
GO

ALTER TABLE Normal.ParallelMain
ADD CONSTRAINT ParallelMain_PK
PRIMARY KEY
(
BookNumber,
ChapterNumber,
VerseNumber,
WordNumber
)
GO

ALTER TABLE Normal.ParallelMain
ADD CONSTRAINT ParallelMain_AK
UNIQUE
(
WordGlobalDefaultSort
)
GO

ALTER TABLE Normal.ParallelMain
ADD CONSTRAINT ParallelMain_AK2
UNIQUE
(
WordGlobalTraditionalSort
)
GO