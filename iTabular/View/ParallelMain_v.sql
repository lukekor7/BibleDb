CREATE VIEW iTabular.ParallelMain_v
AS
SELECT 
	x.VerseId,
	x.WordNumber,
	x.WordGlobalDefaultSort,
	x.WordGlobalTraditionalSort,
	x.WordElementId,
	x.OriginalId,
	x.OriginalText,
	x.TransliterationId,
	x.TransliterationText,
	x.EnglishText,
	x.MorphologyId
FROM Normal.ParallelMain x
GO