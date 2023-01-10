CREATE VIEW iTabular.Verse_v
AS
SELECT DISTINCT
	x.VerseId,
	b.BookLanguageName,
	x.BookNumber,
	b.BookName,
	BookFilterName = b.BookName,
	b.BookDefaultSort,
	b.BookGroupName,
	b.BookGroupSort,
	b.BookSubGroupName,
	b.BookSubGroupSort,
	BookTraditionalName = b.BookName,
	b.BookTraditionalSort,
	x.ChapterNumber,
	ChapterFilterNumber = x.ChapterNumber,
	x.VerseNumber,	
	BibleHubGridLink = 'https://biblehub.com/text/' + b.BookShortName + '/' + CONVERT(NVARCHAR, x.ChapterNumber) + '-' + CONVERT(NVARCHAR, x.VerseNumber) + '.htm',
	BibleHubCommentaryLink = 'https://biblehub.com/commentaries/' + b.BookShortName + '/' + CONVERT(NVARCHAR, x.ChapterNumber) + '-' + CONVERT(NVARCHAR, x.VerseNumber) + '.htm'
FROM Normal.ParallelMain x
	JOIN Normal.Book b
		ON b.BookNumber = x.BookNumber
GO