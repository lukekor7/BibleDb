CREATE PROCEDURE Normal.LoadNormal_pr
AS
BEGIN


TRUNCATE TABLE Normal.Book
INSERT INTO Normal.Book
SELECT *
FROM SourceManual.Book


TRUNCATE TABLE Normal.StrongReference

INSERT INTO Normal.StrongReference
-- Always true
--   StrongLink = '/' + BookLanguageName + '/' + StrongNumber + '.htm'
--   StrongSummary LIKE 'Strong''s ' + BookLanguageName + ' ' + StrongNumber + ': %'
/*  Length 4000 was enough
SELECT LEN(StrongSummaryText), *
 FROM Normal.StrongReference
ORDER BY 1 DESC
*/
--13919
SELECT 
StrongCode = LEFT(BookLanguageName, 1) + StrongNumber,
StrongLanguageName = BookLanguageName, 
StrongNumber, 
StrongSummaryText = LTRIM(RTRIM(RIGHT(StrongSummary, LEN(StrongSummary) - LEN('Strong''s ' + BookLanguageName + ' ' + StrongNumber + ':'))))
 FROM (
	SELECT 
		x.*,
		StrongNumberRow = ROW_NUMBER() OVER (PARTITION BY BookLanguageName, StrongNumber
			-- Some anamolies in StrongSummary data
			--   Use the most occuring
			ORDER BY WordCount DESC)
	FROM (
		SELECT b.BookLanguageName, StrongNumber, StrongSummary, StrongLink, WordCount = COUNT(*)
		FROM NormalStage.ParallelMain x
			JOIN SourceManual.Book b
				ON b.BookShortName = x.BookShortName
		GROUP BY b.BookLanguageName, StrongNumber, StrongSummary, StrongLink
		) x
	) x
WHERE StrongNumber <> ''
AND StrongNumberRow = 1
UNION ALL
SELECT 
StrongCode = 'H',
StrongLanguageName = 'Hebrew',
StrongNumber =  '',
StrongSummaryText = ''
UNION ALL
SELECT 
StrongCode = 'G',
StrongLanguageName = 'Greek',
StrongNumber =  '',
StrongSummaryText = ''


TRUNCATE TABLE Normal.Morphology

/*
-- Morphology not dependant on anything
SELECT x.*
FROM (
	SELECT 
			x.*,
			TransliterationLinkCount = COUNT(*) OVER (PARTITION BY TransliterationLink)
		FROM (
			SELECT TransliterationLink, MorphologyLongText, WordCount = COUNT(*)
			FROM NormalStage.ParallelMain x
			GROUP BY TransliterationLink, MorphologyLongText
			) x
		) x
WHERE TransliterationLink <> '/englishmans_hebrew.htm'
ORDER BY 
	TransliterationLinkCount DESC

-- Morphology not dependant on anything
SELECT x.*
FROM (
	SELECT 
			x.*,
			TransliterationIdCount = COUNT(*) OVER (PARTITION BY TransliterationId)
		FROM (
			SELECT TransliterationId, MorphologyLongText, WordCount = COUNT(*)
			FROM NormalStage.ParallelMain x
			GROUP BY TransliterationId, MorphologyLongText
			) x
		) x
ORDER BY 
	TransliterationIdCount DESC

-- Morphology not dependant on anything
SELECT x.*
FROM (
	SELECT 
			x.*,
			OriginalIdCount = COUNT(*) OVER (PARTITION BY OriginalId)
		FROM (
			SELECT OriginalId, MorphologyLongText, WordCount = COUNT(*)
			FROM NormalStage.ParallelMain x
			GROUP BY OriginalId, MorphologyLongText
			) x
		) x
ORDER BY 
	OriginalIdCount DESC
*/

INSERT INTO Normal.Morphology
(MorphologyShortText,
MorphologyLongText)
SELECT 
	MorphologyShortText,
	MorphologyLongText
FROM (
	SELECT 
			x.*,
			MorphologyShortTextRow = RANK() OVER (PARTITION BY MorphologyShortText ORDER BY WordCount DESC)
		FROM (
			SELECT MorphologyShortText, MorphologyLongText, WordCount = COUNT(*)
			FROM NormalStage.ParallelMain x
			GROUP BY MorphologyShortText, MorphologyLongText
			) x
		) x
WHERE MorphologyShortTextRow = 1


/*
--13534
SELECT *
FROM NormalStage.ParallelMain2
WHERE StrongNumber = ''

--13534
SELECT *
FROM NormalStage.ParallelMain2
WHERE TransliterationLink = '/englishmans_hebrew.htm'
*/


TRUNCATE TABLE Normal.WordElement
INSERT INTO Normal.WordElement
(
	WordElementCode,
	WordElementText,
	TransliterationLink,
	StrongCode
)
SELECT DISTINCT 
	WordElementCode = TransliterationLink,
	WordElementText = y.StrongSummaryText,
	TransliterationLink,
	y.StrongCode
FROM NormalStage.ParallelMain2 x
	JOIN SourceManual.Book b
		ON b.BookShortName = x.BookShortName
	JOIN Normal.StrongReference y
		ON y.StrongNumber = x.StrongNumber
		AND y.StrongLanguageName = b.BookLanguageName
WHERE x.StrongNumber <> ''
UNION ALL
SELECT DISTINCT 
	WordElementCode = EnglishText,
	WordTElementext = EnglishText,
	TransliterationLink,
	StrongCode = LEFT(b.BookLanguageName, 1)	
FROM NormalStage.ParallelMain2 x
	JOIN SourceManual.Book b
		ON b.BookShortName = x.BookShortName
WHERE x.StrongNumber = ''


TRUNCATE TABLE Normal.ParallelMain
INSERT INTO Normal.ParallelMain
SELECT 
	b.BookNumber,
	x.ChapterNumber,
	x.VerseNumber,
	VerseId = RANK() OVER (ORDER BY	b.BookNumber, x.ChapterNumber, x.VerseNumber),
	x.WordNumber,
	WordGlobalDefaultSort = ROW_NUMBER() OVER (ORDER BY 
			b.BookDefaultSort,
			x.ChapterNumber,
			x.VerseNumber,
			x.WordNumber),
	WordGlobalTraditionalSort = ROW_NUMBER() OVER (ORDER BY 
			b.BookTraditionalSort,
			x.ChapterNumber,
			x.VerseNumber,
			x.WordNumber),
	WordElementId = ISNULL(we1.WordElementId, we2.WordElementId),
	x.OriginalId,
	x.OriginalText,
	x.TransliterationId,
	x.TransliterationText,
	x.EnglishText,
	m.MorphologyId	
FROM NormalStage.ParallelMain2 x
	JOIN Normal.Book b
		ON b.BookShortName = x.BookShortName
	LEFT JOIN Normal.WordElement we1
		ON we1.WordElementCode = x.TransliterationLink
		AND x.StrongNumber <> ''
	LEFT JOIN Normal.WordElement we2
		ON we2.WordElementCode = x.EnglishText
		AND x.StrongNumber = ''
	JOIN Normal.Morphology m
		ON m.MorphologyShortText = x.MorphologyShortText

END
GO