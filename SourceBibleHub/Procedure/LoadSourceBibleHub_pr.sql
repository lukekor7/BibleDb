CREATE PROCEDURE SourceBibleHub.LoadSourceBibleHub_pr
AS
BEGIN

/*  
-- Find errors in source HTML
--   Must are simply puncuation issues
--   Corrections file resolves all issuses, loaded with "x" prefix for book name
SELECT *
FROM SourceBibleHubStage.ParallelMain
WHERE ISNULL(StrongNumber, '') = ''
  and OriginalLink = ''

SELECT *
FROM SourceBibleHubStage.ParallelMain
WHERE OriginalLink = ''
order by 1,2,3,4

SELECT *
FROM SourceBibleHubStage.ParallelMain
WHERE 
	 --numbers all the same anomaly
	--(BookShortName = 'numbers' AND ChapterNumber = 10 AND VerseNumber = 34) -- punc
	--OR (BookShortName = 'numbers' AND ChapterNumber = 10 AND VerseNumber = 36) -- punc

	-- psalms all the same anomaly
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 20 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 21 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 22 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 23 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 24 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 25 -- punc
	--BookShortName = 'psalms' AND ChapterNumber = 107 AND VerseNumber = 39 -- punc

	BookShortName = 'proverbs' AND ChapterNumber = 24 AND VerseNumber = 17
ORDER BY 1,2,3,4


*/
TRUNCATE TABLE SourceBibleHub.ParallelMain

INSERT SourceBibleHub.ParallelMain
SELECT x.*
FROM SourceBibleHubStage.ParallelMain x
	LEFT JOIN SourceBibleHubStage.ParallelMain y
		ON y.BookShortName = 'x' + x.BookShortName
		AND y.ChapterNumber = x.ChapterNumber
		AND y.VerseNumber = x.VerseNumber
		AND y.WordNumber = x.WordNumber
WHERE x.BookShortName NOT LIKE 'x%'
  AND y.BookShortName IS NULL
UNION ALL
-- Capable of inserting new content
--   2 Pet 3:10 has HTML error
SELECT 
	BookShortName = RIGHT(x.BookShortName, LEN(x.BookShortName) -1),
	x.ChapterNumber,
	x.VerseNumber,
	x.WordNumber,
	x.StrongNumber,
	x.StrongSummary,
	x.StrongLink,
	x.OriginalText,
	x.OriginalPseudo,
	x.OriginalLink,
	x.EnglishText,
	x.MorphShortText,
	x.MorphLongText
FROM SourceBibleHubStage.ParallelMain x
WHERE x.BookShortName LIKE 'x%'
  -- Error in HTML on source
  AND x.StrongNumber <> 'DELETE'
END
GO