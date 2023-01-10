CREATE TABLE Normal.StrongReference
(
StrongCode VARCHAR(6) NOT NULL,
StrongLanguageName VARCHAR(30) NOT NULL, 
StrongNumber VARCHAR(5) NOT NULL, 
StrongSummaryText NVARCHAR(4000) NOT NULL
)
GO

ALTER TABLE Normal.StrongReference
ADD CONSTRAINT StrongReference_PK
PRIMARY KEY
(
StrongCode
)
GO

ALTER TABLE Normal.StrongReference
ADD CONSTRAINT StrongReference_AK1
UNIQUE
(
StrongLanguageName,
StrongNumber
)
GO