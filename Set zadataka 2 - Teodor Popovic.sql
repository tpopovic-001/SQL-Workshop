

BEGIN TRAN

-- 1. Napraviti novu tabelu (Firm_{ImePrezime}) po uzoru na postojecu u koju cemo presuti samo Firme koje su sponzorisane (IsSponsored)
SELECT 
*
INTO Firm_TeodorPopovic
FROM dbo.Firm
WHERE IsSponsored=1;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM Firm_TeodorPopovic;
GO
DROP TABLE Firm_TeodorPopovic;

BEGIN TRAN

-- 2. Napraviti novu tabelu (FirmArticle_{ImePrezime}) koja ce imate kolone 
--Id, Type, Title u koju cemo presuti sve firme i article. 
-- Type kolonu u slucaju ako je firma popuniti sa 'Firm', ako je u pitanju Article popuniti sa 'Article'

SELECT
	*
INTO FirmArticle_TeodorPopovic
FROM dbo.FirmArticle;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM FirmArticle_TeodorPopovic; 
GO
DROP TABLE FirmArticle_TeodorPopovic;

BEGIN TRAN

-- 4. Napraviti novu tabelu, kopiju tabele Firm u tabelu koja ce da nam sluzi za vezbanje update statementa. 
-- Nova tabela treba da se zove (FirmForPractice_{ImePrezime}). Isto uraditi i za tabelu Article. 
-- Nova tabela treba da se zove (ArticleForPractice_{ImePrezime}). Sve dalje INSERT, UPDATE i DELETE statement-e raditi nad novim tabelama

SELECT 
*
INTO FirmForPractice_TeodorPopovic
FROM dbo.Firm;

SELECT
*
INTO ArticleForPractice_TeodorPopovic
FROM dbo.Article;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM FirmForPractice_TeodorPopovic;
SELECT * FROM ArticleForPractice_TeodorPopovic;
GO
DROP TABLE FirmForPractice_TeodorPopovic;
DROP TABLE ArticleForPractice_TeodorPopovic;

BEGIN TRAN

-- 5. Napraviti update statement koji ce da ispravi prazna polja (prazne stringove) u kolona Email i Web tako sto ce da postavi NULL na njih. 
-- Polja koja imaju vrednosti ne diramo.

UPDATE FirmForPractice_TeodorPopovic SET Email = NULL, Web = NULL 
WHERE Email = '' OR Web = ''; 

ROLLBACK TRAN

COMMIT TRAN
SELECT TOP 100 * FROM FirmForPractice_TeodorPopovic

BEGIN TRAN

-- 6. Napraviti update statement koji ce da proveri da li su Phone i Fax kolona ista (imaju istu vrednost) ukoliko imaju istu vrednost,
-- kolona Fax treba da se podesi na NULL. Kolonu Phone ne diramo.

UPDATE FirmForPractice_TeodorPopovic SET Fax = NULL 
WHERE Phone = Fax;
ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM FirmForPractice_TeodorPopovic;

BEGIN TRAN

-- 7. Napraviti update statement koji ce da ispegla kolonu [Web] na nacin tako sto ce da svaku vrednost koja se zavrsava sa 
-- / (http://www.google.com/) da ukloni krajnji / i ostane vrednost npr http://www.google.com

UPDATE FirmForPractice_TeodorPopovic SET Web= RTRIM(Web,'/') WHERE Web LIKE '%/'
ROLLBACK TRAN

COMMIT TRAN
SELECT Web FROM FirmForPractice_TeodorPopovic WHERE Web NOT LIKE '%/';

BEGIN TRAN

-- 8. Ubaciti novi red u tabelu [ArticleForPractice_{ImePrezime}]. 
-- Novi red treba da bude kopija vec postojeceg reda koji ima ID 41. 
-- Sve numericke vrednosti ostaju iste, sve tekstualne vrednosti treba da imaju dodatu vrednost 'Copy' na kraju svojih vrednosti. 
-- Sve datumske vrednosti treba da budu vece za 3 dana u odnosu na inicijalni red. Isprisati u konzoli ID reda koji smo dodali. Skripta treba da bude idempotentna.

INSERT INTO ArticleForPractice_TeodorPopovic 
SELECT 
	EntityStatus,
	IsFeatured,
	Title + 'Copy' AS 'Title',
	ShortDescription + 'Copy' AS 'ShortDescription',
	Body + 'Copy' AS 'Body',
	Period_Id,
	Sponsor_Id,
	[Type_Id],
	DATEADD(DAY,3,CreateDate) AS 'CreateDate',
	Author + 'Copy' AS 'Author',
	[Location] + 'Copy' AS 'Location',
	NumberOfVisits,
	Image_Id,
	DATEADD(DAY,3,[ExpireDate]) AS 'ExpireDate',
	ExternalId,
	IsSponsored,
	IsTopFeatured,
	DATEADD(DAY,3,CreatedOn) AS 'CreatedOn',
	DATEADD(DAY,3,LastUpdatedOn) AS 'LastUpdatedOn',
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id
FROM ArticleForPractice_TeodorPopovic WHERE Id = 41;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM ArticleForPractice_TeodorPopovic WHERE Id = SCOPE_IDENTITY();

BEGIN TRAN

-- 9. Update-ovati Article sa ID-jem 59. Title treba da bude 'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'

UPDATE ArticleForPractice_TeodorPopovic SET Title= N'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж' WHERE Id=59;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM ArticleForPractice_TeodorPopovic WHERE Id=59;

BEGIN TRAN

-- 10. Iskopirati redove iz tabele Firm i dodati ih kao nove. 
-- Redove koje zelimo da iskopiramo imaju sledece ID-jeve (3, 4, 5, 6, 7, 8, 9, 10). Sva tekstualna polja treba da imaju sufix Copy

INSERT INTO FirmForPractice_TeodorPopovic 
SELECT
	[Name] + 'Copy' AS 'Name',
	Country_Id,
	GlobalFirm_Id,
	IsSponsored,
	[Description] + 'Copy' AS 'Description',
	EntityStatus,
	Address_Id,
	Phone + 'Copy' AS 'Phone',
	Fax + 'Copy' AS 'Fax',
	Email + 'Copy' AS 'Email',
	Web + 'Copy' AS 'Web',
	FirmType,
	Editor_Id,
	Logo_Id,
	IconRecognition_Id,
	Advert_Id,
	IconRecognition2_Id,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	LastUpdatedBy_Id,
	UpdatedForNextYear,
	EMLUpgrade,
	InsightUrl + 'Copy' AS 'InsightUrl',
	InsightImage_Id,
	ProfileType,
	SubmissionToolId
FROM dbo.Firm WHERE Id IN(3, 4, 5, 6, 7, 8, 9, 10);

ROLLBACK TRAN

COMMIT TRAN
SELECT TOP 8 * FROM dbo.FirmForPractice_TeodorPopovic ORDER BY Id DESC;

BEGIN TRAN

-- 11. Napraviti privremenu praznu (temp) tabelu na osnovu Tabele Firm

SELECT TOP 0
* 
INTO #TempTabela_TeodorPopovic
FROM dbo.Firm;

ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM #TempTabela_TeodorPopovic;

BEGIN TRAN

-- 12. Napraviti privremenu temp tabelu sa sledecim kolonama (Identifikator, NazivFirme) u tu tabelu insertovati sve redove iz tabele [Firm]. 
-- Firm.Id -> Identifikator, Firm.Name -> NazivFirme. Insertovani redovi treba da budu sortirani po nazivu firme.

SELECT
	Firm.Id AS 'Indentifikator',
	Firm.[Name] AS 'NazivFirme'
INTO #TempTabela2_TeodorPopovic
FROM dbo.Firm
ORDER BY [Name];


ROLLBACK TRAN

COMMIT TRAN
SELECT * FROM #TempTabela2_TeodorPopovic;