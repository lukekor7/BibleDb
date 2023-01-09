CREATE PROCEDURE NormalStage.LoadNormalStage_pr
AS
BEGIN

TRUNCATE TABLE NormalStage.ParallelMain

-- Adding Id to help with joins, other normalization
/*
SELECT OriginalText, COUNT(*)
FROM (
SELECT DISTINCT OriginalId, OriginalText
FROM NormalStage.ParallelMain x
) x
GROUP BY OriginalText
ORDER BY 2 DESC


SELECT TransliterationText, COUNT(*)
FROM (
SELECT DISTINCT TransliterationId, TransliterationText
FROM NormalStage.ParallelMain x
) x
GROUP BY TransliterationText
ORDER BY 2 DESC
*/

INSERT NormalStage.ParallelMain
SELECT 
x.BookShortName,
x.ChapterNumber,
x.VerseNumber,
x.WordNumber,
x.StrongNumber,
x.StrongSummary,
x.StrongLink,
OriginalId = RANK() OVER (ORDER BY x.OriginalText),
x.OriginalText,
TransliterationId = RANK() OVER (ORDER BY x.OriginalPseudo),
TransliterationText = x.OriginalPseudo,
TransliterationLink = x.OriginalLink,
x.EnglishText,
MorphologyShortText = x.MorphShortText,
MorphologyLongText = x.MorphLongText
FROM SourceBibleHub.ParallelMain x


TRUNCATE TABLE NormalStage.ParallelMain2
INSERT NormalStage.ParallelMain2
SELECT 
	x.BookShortName,
	x.ChapterNumber,
	x.VerseNumber,
	x.WordNumber,
	x.StrongNumber,
	-- Normalized
	--x.StrongSummary,
	--x.StrongLink,
	x.OriginalId,
	x.OriginalText,
	x.TransliterationId,
	x.TransliterationText,
	TransliterationLink = ISNULL(y.CorrectTransliterationLink, x.TransliterationLink),
	x.EnglishText,
	x.MorphologyShortText,
	x.MorphologyLongText
  FROM NormalStage.ParallelMain x
		LEFT JOIN (
			-- Same transliteration link should always have same strong
			--   Fix exceptions
			--   All were checked manually 
			--    /greek/einai_1511.htm does not have a clean resolution
			SELECT 
				TransliterationLink,
				StrongNumber,
				CorrectTransliterationLink = LEFT(TransliterationLink, LEN(TransliterationLink) - 8) + RIGHT('_' + StrongNumber, 4) + '.htm'
			 FROM (
				SELECT 
					x.*,
					TransliterationLinkCount = COUNT(*) OVER (PARTITION BY TransliterationLink),
					StrongNumberCount = COUNT(*) OVER (PARTITION BY StrongNumber)
				FROM (
					SELECT TransliterationLink, StrongNumber, WordCount = COUNT(*)
					FROM NormalStage.ParallelMain
					GROUP BY TransliterationLink, StrongNumber
					) x
				) x
			WHERE TransliterationLinkCount = 2
			  AND RIGHT(TransliterationLink, 8) <> RIGHT('_' + StrongNumber, 4) + '.htm'
			  ) y
		ON y.TransliterationLink = x.TransliterationLink
		AND y.StrongNumber = x.StrongNumber

END
GO