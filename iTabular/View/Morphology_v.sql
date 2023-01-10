CREATE VIEW iTabular.Morphology_v
AS 
SELECT
x.MorphologyId,
x.MorphologyShortText,
x.MorphologyLongText
FROM Normal.Morphology x
GO