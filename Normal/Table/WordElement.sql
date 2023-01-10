CREATE TABLE Normal.WordElement
(
WordElementId    INT IDENTITY(1,1) NOT NULL,
WordElementCode  NVARCHAR(200) NOT NULL,
WordElementText  NVARCHAR(4000) NOT NULL,
TransliterationLink  NVARCHAR(200) NOT NULL,
StrongCode   	 VARCHAR(6)
)
GO

ALTER TABLE Normal.WordElement
ADD CONSTRAINT WordElement_PK
PRIMARY KEY
(
WordElementId
)
GO

ALTER TABLE Normal.WordElement
ADD CONSTRAINT WordElement_AK1
UNIQUE
(
WordElementCode
)
GO