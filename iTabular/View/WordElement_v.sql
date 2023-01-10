CREATE VIEW iTabular.WordElement_v
AS
SELECT 
	we.WordElementId,
	we.WordElementText,
	we.StrongCode,
	BibleHubTransliterationLink = 'https://biblehub.com' + we.TransliterationLink,
	BibleHubStrongLink = 'https://biblehub.com/' + LOWER(st.StrongLanguageName) + '/' + st.StrongNumber + '.htm'
FROM Normal.WordElement we
	JOIN Normal.StrongReference st
		ON st.StrongCode = we.StrongCode
GO