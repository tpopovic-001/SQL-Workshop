-- 1. Poslednjih (CreatedDate) 10 artikala koji su IsSponsored

SELECT TOP(10)
	*
FROM dbo.Article WHERE IsSponsored = 1
ORDER BY CreateDate DESC;

-- 2. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) imaju 'Legal'

SELECT TOP(20)
	*
FROM dbo.Article WHERE Title LIKE '%Legal%'
ORDER BY CreateDate DESC;

-- 3. Poslednjih 10 (CreatedDate) artikala koji u svom nazivu (Title) pocinju sa 'Legal'

SELECT TOP(10)
	*
FROM dbo.Article WHERE Title LIKE 'Legal%'
ORDER BY CreateDate DESC;

-- 4. Poslednjih 20 (CreatedDate) artikala koji u svom nazivu (Title) zavrsavaju sa 'Legal'

SELECT TOP(20)
	*
FROM dbo.Article WHERE Title LIKE '%Legal'
ORDER BY CreateDate DESC;

-- 5. Prvih 10 (CreatedDate) artikala kojima se zavrsavaju (ExpireDate) u 2019 godinu

SELECT TOP(10)
	*
FROM dbo.Article WHERE YEAR([ExpireDate]) = '2019'
ORDER BY CreateDate; 

-- 5. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.09.2018 - 31.12.2018 // u mejlu pise kao jos jedan primer pod brojem 5. 

SELECT
	*
FROM dbo.Article WHERE [ExpireDate] BETWEEN '2018-09-01'AND '2018-12-31';

-- 6. Sve artikle kojima je rok zavrsetka u (ExpireDate) u sledecem periodu: 01.01.2019 - 31.12.2020, 
-- prikazati samo odredjene kolone: Id, Title, Author, IsSponsored. IsSponsored ne zelimo da prikazemo kao nule i jedinice vec zelimo da ih prikazemo kao Yes/No

SELECT
	Id,
	Title,
	Author,
	CASE IsSponsored
		WHEN 0 THEN 'No'
		WHEN 1 THEN 'Yes'
	END AS 'IsSponsored'
FROM dbo.Article WHERE [ExpireDate] BETWEEN '2019-01-01' AND '2020-12-31';

-- 7. Najvise 10 artikala koji imaju najvecu posecenost (NumberOfVisits) koji su napravljeni 2018 i 2019 godine

SELECT TOP(10)
	Title,
	CreatedOn,
	NumberOfVisits
FROM dbo.Article 
WHERE CreatedOn BETWEEN '2018' AND '2019' 
ORDER BY NumberOfVisits DESC;

-- 8. Poslednjih (CreatedDate) 100 artikala cija duzina Title ne prelazi 30 karaktera

SELECT TOP(100)
	*
FROM dbo.Article WHERE LEN(Title) <= 30
ORDER BY CreateDate DESC;

-- 9. Poslednjih (CreatedDate) 200 artikala (zelim sve kolone iz tabele) i ne zelim da vidim nijednu NULL vrednost. Umesto NULL vrednosti prikazati N/A

SELECT TOP(200)
	Id,
	EntityStatus,
	IsFeatured,
	Title,
	ShortDescription,
	Body,
	Period_Id,
	COALESCE(CONVERT(VARCHAR,Sponsor_Id), 'N/A') AS 'Sponsor_Id',
	[Type_Id],
	CreateDate,
	COALESCE(Author,'N/A') AS 'Author',
	COALESCE([Location],'N/A') AS 'Location',
	NumberOfVisits,
	COALESCE(CONVERT(VARCHAR,Image_Id),'N/A') AS 'Image_Id',
	[ExpireDate],
	COALESCE(CONVERT(VARCHAR,ExternalId),'N/A') AS 'ExternalId',
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id
FROM dbo.Article
ORDER BY CreateDate DESC;

-- 10. Smatramo da su artikli poverljivi ako u svom Title imaju kljucnu rec: Panama. 
-- Zelim da prikazem prvih (ExpiryDate) 500 artikala (zelim sve kolone iz tabele, osim Body) 
-- koji su poverljivi, da prikazem dodatnu kolonu SecretYear: koja treba da izgleda ovako: 
-- Secret {ExpiryDate.Year} number of visits {NumberOfVisits} da budu sortirani po NumberOfVisits u opadajucem redosledu

SELECT TOP(500)
	Id,
	EntityStatus,
	IsFeatured,
	Title,
	ShortDescription,
	Period_Id,
	Sponsor_Id,
	[Type_Id],
	CreateDate,
	Author,
	[Location],
	NumberOfVisits,
	Image_Id,
	[ExpireDate],
	ExternalId,
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id, 
	'Secret {' + CONVERT(VARCHAR,YEAR([ExpireDate])) +'} number of visits {'+ CONVERT(VARCHAR,NumberOfVisits) +'}' AS 'SecretYear'	 
FROM dbo.Article
WHERE Title LIKE '%Panama%'
ORDER BY [ExpireDate],NumberOfVisits DESC; 

-- 11. Zelim da napravim izvestaj i da tekstualno opisem kakva je posecenost artikala bila (NumberOfVisits). 
-- Smatram da je artikal slabo posecen ako je imao manje od 1000 pregleda. Smatram da je artikal srednje posecen ako je imao izmedju 1000 i 2000 pregleda. 
-- Smatram da je artikal visoko posecen ako je imao vise od 3000 pregleda. Dodatna kolona u kojoj je opisana posecenost treba da se zove 'NumberOfVisitsDescriptive'. 
-- Kolone koje zelim da prikazem su: Id, Title, NumberOfVisitsDescriptive. Izvestaj treba da bude sortiran po Article.Title u rastucem redosledu.

SELECT
	Id,
	Title,
	CASE 
		WHEN NumberOfVisits < 1000 THEN 'Slaba posecenost'
		WHEN NumberOfVisits BETWEEN 1000 AND 2000 THEN 'Srednja posecenost'
		WHEN NumberOfVisits > 3000 THEN 'Visoka posecenost'
	END AS 'NumberOfVisitsDescriptive'
FROM dbo.Article
ORDER BY Title;

-- 12. Prikazati sve firme (tabela Firm) koje imaju email adresu (Email). Smatra se da firma ima email adresu AKKO polje nije null i ako polje ima vrednost

SELECT
	*
FROM dbo.Firm
WHERE Email IS NOT NULL AND Email <> ''; 

-- 13. Prikazati sve firme koje imaju u isto vreme email adresu i web adresu (Web).

SELECT
	*
FROM dbo.Firm
WHERE Email IS NOT NULL AND Email <> '' AND
	  Web IS NOT NULL;

-- 14. Prikazati sve firme koje nemaju email adresu (Email).

SELECT
	*
FROM dbo.Firm
WHERE Email IS NULL OR Email = '';

-- 15. Prikazati sve firme koje nemaju email adresu i nemaju web adresu (Web).

SELECT
	*
FROM dbo.Firm
WHERE Email IS NULL OR Email = '' 
AND Web IS NULL;

-- 16. Prikazati sve firme koje imaju web adresu ali nemaju email adresu.

SELECT
	*
FROM dbo.Firm 
WHERE Web IS NOT NULL AND Email = '';

-- 17. Prikazati sve firme koje imaju Logo (Logo_Id)

SELECT
	*
FROM dbo.Firm
WHERE Logo_Id IS NOT NULL;

-- 	18. Prikazati sve firme koje nemaju Logo (Logo_Id)
	
SELECT
	*
FROM dbo.Firm
WHERE Logo_Id IS NULL;

-- 19. Prikazati sve firme koje imaju Logo i koje su update-ovane u poslednje 3 godine

SELECT
	*
FROM dbo.Firm
WHERE Logo_Id IS NOT NULL AND LastUpdatedOn BETWEEN DATEADD(YEAR,-3,GETDATE()) AND GETDATE();

-- 20. Prikazati sve Artikle koji imaju ExpireDate u poslednja 3 meseca od trenutka izvrsenja querija 

SELECT
	*
FROM dbo.Article
WHERE [ExpireDate] BETWEEN DATEADD(MONTH,-3,GETDATE()) AND GETDATE();

-- 21. Prikazati sve Artikle koji imaju ExpireDate u poslednjih 30 dana od trenutka izvrsenja querija

SELECT 
	*
FROM dbo.Article
WHERE [ExpireDate] BETWEEN DATEADD(DAY,-30,GETDATE()) AND GETDATE();

-- 22. Prikazati sve Artikle koji imaju ExpireDate u buducnosti od trenutka izvrsenja querija

SELECT
	*
FROM dbo.Article
WHERE [ExpireDate] > GETDATE(); 

-- 23. Prikazati sve artikle koji se odnose na Mexico (Location) i koji imaju NumberOfVisits veci od 100

SELECT
	*
FROM dbo.Article
WHERE [Location] = 'Mexico' AND NumberOfVisits > 100;

-- 24. Napraviti izvestaj koji ima sledece kolone:
-- Id, TitleAuthorNumberOfVisits
-- Kolona TitleAuthorNumberOfVisits treba da bude u sledecem formatu: 
-- {Title} - Author: {Author}, number of visits: {NumberOfVisits} za sve artikle koji nisu istekli (ExpireDate)

SELECT
	Id,
	'{'+ Title +'} - Author: {'+ Author +'}, number of visits: {'+ CONVERT(VARCHAR,NumberOfVisits) +'} za sve artikle koji nisu istekli ('+ CONVERT(VARCHAR,[ExpireDate]) +')' AS 'TitleAuthorNumberOfVisits'
FROM dbo.Article
WHERE [ExpireDate] > GETDATE();
 

-- 25. Prikazati koji sve razliciti domeni postoje medju advokatima (Lawyer) na osnovu njihove email adrese (gde email adresa postoji)
 
SELECT
	SUBSTRING(Email,CHARINDEX('@',Email),LEN(Email)) AS 'Email domains'
FROM dbo.Lawyer
WHERE Email IS NOT NULL AND Email <> '';

-- 26. Prikazati sve razlicite domene email adresa medju advokatima (Layer) od advokata koji su poslednji put update-ovani u poslednjem kvartalu 2023 godine

SELECT
	SUBSTRING(Email,CHARINDEX('@',Email),LEN(Email)) AS 'Email domains'
FROM dbo.Lawyer
WHERE LastUpdatedOn BETWEEN '2023-10-01' AND '2023-12-31' AND
Email IS NOT NULL AND Email <> '';