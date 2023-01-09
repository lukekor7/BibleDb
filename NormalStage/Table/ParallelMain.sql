CREATE TABLE NormalStage.ParallelMain
(
	BookShortName	NVARCHAR(100),
	ChapterNumber   INT,
	VerseNumber		INT,
	WordNumber		INT,
	StrongNumber	NVARCHAR(10),
	StrongSummary	NVARCHAR(MAX),
	StrongLink	    NVARCHAR(200),
	OriginalId      INT,
	OriginalText    NVARCHAR(200),
	TransliterationId    INT,
	TransliterationText  NVARCHAR(200),
	TransliterationLink   NVARCHAR(200),
	EnglishText     NVARCHAR(200),
	MorphologyShortText  NVARCHAR(200),
	MorphologyLongText   NVARCHAR(200)
)
GO