CREATE PROCEDURE Normal.LoadNormal_pr
AS
BEGIN

TRUNCATE TABLE Normal.StrongReference

INSERT INTO Normal.StrongReference
-- Always true
--   StrongLink = '/' + BookLanguageName + '/' + StrongNumber + '.htm'
--   StrongSummary LIKE 'Strong''s ' + BookLanguageName + ' ' + StrongNumber + ': %'
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


END
GO