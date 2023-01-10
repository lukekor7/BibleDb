CREATE TABLE Normal.Morphology
(
MorphologyId  INT IDENTITY(1,1) NOT NULL,
MorphologyShortText  NVARCHAR(200) NOT NULL,
MorphologyLongText   NVARCHAR(200) NOT NULL
)
GO

ALTER TABLE Normal.Morphology
ADD CONSTRAINT Morphology_PK
PRIMARY KEY
(
MorphologyId
)
GO

ALTER TABLE Normal.Morphology
ADD CONSTRAINT Morphology_AK1
UNIQUE
(
MorphologyShortText
)
GO