CREATE TABLE SourceBibleHubStage.ParallelMain
(
	BookShortName	NVARCHAR(100),
	ChapterNumber   INT,
	VerseNumber		INT,
	WordNumber		INT,
	StrongNumber	NVARCHAR(10),
	StrongSummary	NVARCHAR(MAX),
	StrongLink	    NVARCHAR(200),
	OriginalText    NVARCHAR(200),
	OriginalPseudo  NVARCHAR(200),
	OriginalLink    NVARCHAR(200),
	EnglishText     NVARCHAR(200),
	MorphShortText  NVARCHAR(200),
	MorphLongText   NVARCHAR(200)
)
