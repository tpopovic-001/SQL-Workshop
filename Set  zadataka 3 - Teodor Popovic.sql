-- 1.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti LEFT JOIN)

SELECT
*
FROM dbo.[Lookup] AS l LEFT JOIN dbo.Jurisdiction AS j
ON l.Id = j.Id
WHERE j.Id IS NULL;

-- 2.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na Jurisdiction (koristiti RIGHT JOIN)

SELECT 
	*
FROM dbo.Jurisdiction AS j RIGHT JOIN dbo.[Lookup] AS l
ON j.Id = l.Id
WHERE j.Id IS NULL;

-- 3.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti LEFT JOIN)

SELECT
	*
FROM dbo.[Lookup] AS l LEFT JOIN dbo.PracticeArea AS pa 
ON l.Id = pa.Id
WHERE pa.Id IS NULL;

-- 4.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti RIGHT JOIN)

SELECT
	*
FROM dbo.PracticeArea AS pa RIGHT JOIN dbo.[Lookup] AS l
ON pa.Id = l.Id
WHERE pa.Id IS NULL;

-- 5.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti LEFT JOIN)

SELECT
	*
FROM dbo.[Lookup] AS l LEFT JOIN dbo.IndustrySector AS ind
ON l.Id = ind.Id
WHERE ind.Id IS NULL;

-- 6.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na IndustrySector (koristiti RIGHT JOIN)

SELECT
	*
FROM dbo.IndustrySector AS ind RIGHT JOIN dbo.[Lookup] AS l
ON ind.Id = l.Id
WHERE ind.Id IS NULL;

-- 7.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti LEFT JOIN)
																											-- 7. i 8. primer su isti kao 3. i 4.																										
-- 8.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na PracticeArea (koristiti RIGHT JOIN)

-- 9.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti LEFT JOIN)

SELECT 
	* 
FROM dbo.[Lookup] AS l	LEFT JOIN dbo.LawyerTier AS lt
ON  l.Id = lt.Id
WHERE lt.Id IS NULL;

-- 10.	Prikazati sve vrednosti iz Lookup tabele koje se ne odnose na LayerTier (koristiti RIGHT JOIN)

SELECT 
	* 
FROM dbo.LawyerTier AS lt RIGHT JOIN dbo.[Lookup] AS l 
ON  lt.Id = l.Id
WHERE lt.Id IS NULL;

-- 11.	Prikazati sledece kolone iz tabele Firm (Id, Name, [Country/GlobalFirm]). Kolona [Country/GlobalFirm] 
-- treba da prikaze vezan Country name (Country_Id) za firmu ukoliko firma ima Country. 
-- Ukoliko nema, treba da prikaze vezanu globalnu firmu - naziv globalne firme (GlobalFirm_Id). Ukoliko nema Globalnu firmu treba da prikaze 'N/A'.

SELECT
	f.Id,
	f.[Name],
	CASE
		WHEN f.Country_Id IS NOT NULL THEN 'Country: ' + c.[Name]
		WHEN f.GlobalFirm_Id IS NULL THEN 'N/A'
		WHEN f.Country_Id IS NULL THEN 'Global firm name: ' + f.[Name]
	END AS 'Country/GlobalFirm'
FROM dbo.Firm AS f LEFT JOIN dbo.Country AS c 
ON f.Country_Id = c.Id LEFT JOIN dbo.Firm AS f2 
ON f.Id = f2.GlobalFirm_Id ORDER BY [Country/GlobalFirm] -- Order by sam cisto uradio da bi se lakse videli rezultati iz kolone Country/GlobalFirm;

-- 12.	Prikazati sledece kolone iz tabele Firm (Id, Name, Address). 
-- Kolonu Address pravimo na osnovu spoljnog kljuca Address_Id. 
-- Ideja je da prikazemo samo one kolone iz tabele Address koje imaju vrednost u sledecem redosledu: Line1 Line2 Line3 POBox, Country. 
-- Ona polja iz tabele Address koja nemaju vrednost ne prikazujemo. 
-- Country prikazujemo na osnovu spoljnog kljuca Country_Id (napraviti vezu sa Country) I prikazati naziv zemlje.
-- Naziv zemlje takodje prikazujemo samo ako postoji.

SELECT
	f.Id,
	f.[Name],
	'Line1: {' + addr.Line1 + '}, Line2: {' + addr.Line2 + '}, Line 3: {' + addr.Line3 + '}, POBox: {'+ addr.POBox + '},' + ' Country: {' + c.[Name] + '}'  
	AS 'Address'
FROM dbo.Firm AS f INNER JOIN dbo.[Address] AS addr
ON f.Address_Id = addr.Id INNER JOIN dbo.Country AS c
ON addr.Country_Id = c.Id
WHERE addr.Line1 IS NOT NULL AND
addr.Line1 <> '' AND Line2 IS NOT NULL AND
addr.Line2 <> '' AND Line3 IS NOT NULL AND
addr.Line3 <> '' AND addr.POBox IS NOT NULL AND
addr.POBox <> '';

-- 13.	Prikazati sledece kolone iz tabele Firm 
-- (Id, Name, Logo, IconRecognition, Advert, IconRecognition2). 
-- Logo, IconRecognition, Advert, IconRecognition2 izvuci na osnovu njihovih spoljnih kljuceva iz relevantne tabele kao FileName. 
-- Ukoliko nemaju vrednosti u spoljnom kljucu, prikazati prazan string.

SELECT
	f.Id,
	f.[Name],
	ISNULL(logo.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),logo.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,logo.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,logo.Active),'') AS 'Logo',
	ISNULL(ic.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),ic.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic.Active),'') AS 'IconRecognition',
	ISNULL(ad.ImageName,'') + ' ' + ISNULL(ad.[Url],'') + ' ' + ISNULL(CONVERT(VARCHAR,ad.Active),'') AS 'Advert',
	ISNULL(ic2.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),ic2.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic2.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic2.Active),'') AS 'IconRecognition2'
FROM dbo.Firm AS f LEFT JOIN dbo.[File] AS logo ON
f.Logo_Id = logo.Id LEFT JOIN dbo.[File] AS ic  ON	
f.IconRecognition_Id = ic.Id LEFT JOIN dbo.[File] AS ic2 ON
f.IconRecognition2_Id = ic2.Id LEFT JOIN dbo.Advert AS ad ON
f.Advert_Id = ad.Id 

-- 14.	Prikazati sve kolone iz tabele Firm I umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje 
-- (prikazati Name, Title, Value, sto god od toga povezani entitet poseduje). 
-- Ideja je da ne vidim nikakve spoljne kljuceve u svom izvestaju, vec njihove vrednosti. 
-- Nazivi takvih kolona ne treba da imaju _Id kao sufix. Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.

SELECT
	f.[Name],
	ISNULL(c.[Name],'') AS 'Country',
	ISNULL(f2.[Name],'') AS 'GlobalFirm',
	f.IsSponsored,
	f.[Description],
	f.EntityStatus,
	ISNULL(a.Line1,'') + ' ' + ISNULL(a.Line2,'') + ' ' + ISNULL(a.Line3,'') + ' ' + ISNULL(a.POBox,'') + ISNULL(CONVERT(NVARCHAR,c2.Id),'') + ' ' + ISNULL(c2.Name,'') AS 'Address',
	ISNULL(f.Phone,'') AS 'Phone',
	ISNULL(f.Fax,'') AS 'Fax',
	ISNULL(f.Email,'') AS 'Email',
	ISNULL(f.Web,'') AS 'Web',
	f.FirmType,
	ISNULL(creator.Email,'') + ' ' + ISNULL(editor.Forename,'') + ' ' + ISNULL(editor.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,editor.[Role]),'') AS 'Editor',
	ISNULL(logo.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),logo.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,logo.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,logo.Active),'') AS 'Logo',
	ISNULL(ic.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),ic.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic.Active),'') AS 'IconRecognition',
	ISNULL(ad.ImageName,'') + ' ' + ISNULL(ad.[Url],'') + ' ' + ISNULL(CONVERT(VARCHAR,ad.Active),'') AS 'Advert',
	ISNULL(ic2.OriginalFileName,'') + ' ' + ISNULL(CONVERT(CHAR(36),ic2.StorageFileId),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic2.Category),'') + ' ' + ISNULL(CONVERT(VARCHAR,ic2.Active),'') AS 'IconRecognition2',
	f.CreatedOn,
	f.LastUpdatedOn,
	ISNULL(creator.Email,'') + ' ' + ISNULL(creator.Forename,'') + ' ' + ISNULL(creator.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,creator.[Role]),'') AS 'CreatedBy',
	ISNULL(usrUpdate.Email,'') + ' ' + ISNULL(usrUpdate.Forename,'') + ' ' + ISNULL(usrUpdate.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,usrUpdate.[Role]),'') AS 'LastUpdatedBy'
FROM dbo.Firm AS f LEFT JOIN dbo.Country AS c ON
f.Country_Id = c.Id LEFT JOIN dbo.[Address] AS a ON
f.Address_Id = a.Id LEFT JOIN dbo.Country AS c2 ON	
A.Country_Id = c2.Id LEFT JOIN dbo.[User] AS editor ON
f.Editor_Id = editor.Id LEFT JOIN dbo.[File] logo ON
f.Logo_Id = logo.Id LEFT JOIN dbo.[File] AS ic ON
f.IconRecognition_Id = Ic.Id LEFT JOIN dbo.[File] AS ic2 ON
f.IconRecognition2_Id = Ic2.Id LEFT JOIN dbo.Advert AS ad ON
f.Advert_Id = ad.Id LEFT JOIN dbo.[User] AS creator ON
f.CreatedBy_Id = creator.Id LEFT JOIN dbo.[User] AS usrUpdate ON
f.LastUpdatedBy_Id = usrUpdate.Id LEFT JOIN dbo.[Firm] AS f2 ON
f.GlobalFirm_Id = f2.Id 

-- 15.	Prikazati sve kolone iz tabele LawyerReview. 
-- Umesto spoljnih kljuceva prikazati vrednosti entiteta koji spoljni kljuc pokazuje. Gde nema vrednosti u spoljnom kljucu, prikazati kao prazan string.

SELECT
	lr.EntityStatus,
	ISNULL(lr.Overview,'') AS 'Overview',
	ISNULL(lk.[Name],'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.[Status]),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.CreatedOn),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.LastUpdatedOn),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.CreatedBy_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.LastUpdatedBy_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.Parent_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,lk.[Order]),'') AS 'Jurisdiction',
	ISNULL(l.FirstName,'') + ' ' + ISNULL(l.LastName,'') + ' ' + ISNULL(l.Phone,'') + ' ' + ISNULL(l.Fax,'') + ' ' + ISNULL(l.Email,'') + ' ' + 
	ISNULL(l.Web,'') + ' ' + ISNULL(l.[Language],'') + ' ' + ISNULL(CONVERT(VARCHAR,l.EntityStatus),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.Address_Id),'') + ' ' + 
	ISNULL(CONVERT(VARCHAR,l.Advert_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.Country_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.Editor_Id),'') + ' ' +
	ISNULL(CONVERT(VARCHAR,l.IconRecognition_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.IconRecognition2_Id),'') + ' ' +
	ISNULL(CONVERT(VARCHAR,l.Logo_Id),'') + ' ' + ISNULL(l.JobPosition,'') + ' ' + ISNULL(CONVERT(VARCHAR,l.IsSponsored),'') + ' ' +
	ISNULL(l.LinkedInUrl,'') + ' ' + ISNULL(CONVERT(VARCHAR,l.CreatedOn),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.LastUpdatedOn),'') + ' ' +
	ISNULL(CONVERT(VARCHAR,l.CreatedBy_Id),'') + ' ' + ISNULL(CONVERT(VARCHAR,l.LastUpdatedBy_Id),'') + ' ' + 
	ISNULL(l.AdminEmail,'') + ' ' + ISNULL(CONVERT(VARCHAR,l.Tier_Id),'') + ' ' + ISNULL(l.SourceOfInformation,'') + ' ' +
	ISNULL(CONVERT(VARCHAR,l.IsNotificationSent),'') + ' ' + ISNULL(l.InsightUrl,'') + ' ' + ISNULL(CONVERT(VARCHAR,l.InsightImage_Id),'') AS 'Lawyer',
	ISNULL(CONVERT(VARCHAR,p.Year),'') AS 'Period',
	lr.CreatedOn,
	lr.LastUpdatedOn,
	ISNULL(creator.Email,'') + ' ' + ISNULL(creator.Forename,'') + ' ' + ISNULL(creator.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,creator.[Role]),'') AS 'CreatedBy',
	ISNULL(creator.Email,'') + ' ' + ISNULL(editor.Forename,'') + ' ' + ISNULL(editor.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,editor.[Role]),'') AS 'Editor',
	ISNULL(usrUpdate.Email,'') + ' ' + ISNULL(usrUpdate.Forename,'') + ' ' + ISNULL(usrUpdate.Surname,'') + ' ' + ISNULL(CONVERT(VARCHAR,usrUpdate.[Role]),'') AS 'LastUpdatedBy'
FROM dbo.LawyerReview AS lr LEFT JOIN dbo.Jurisdiction AS j ON
lr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk ON
j.Id = lk.Id LEFT JOIN dbo.Lawyer AS L ON
lr.Lawyer_Id = l.Id LEFT JOIN dbo.[Period] AS p ON
lr.Period_Id = p.Id LEFT JOIN dbo.[User] AS creator ON
lr.CreatedBy_Id = creator.Id LEFT JOIN dbo.[User] AS editor ON
lr.Editor_Id = editor.Id LEFT JOIN dbo.[User] AS usrUpdate ON
lr.LastUpdatedBy_Id = usrUpdate.Id
 
-- 16.	Prikazati sve jurisdikcije [Jurisdiction] za koje ne postoji nijedan [LawyerReview].

SELECT
	*
FROM dbo.Jurisdiction AS j LEFT JOIN dbo.LawyerReview AS lr
ON j.Id = lr.Jurisdiction_Id
WHERE lr.Jurisdiction_Id IS NULL;

-- 17.	Prikazati sve [Lawyer] entitete za koje ne postiji nijedan LawyerReview

SELECT
	lw.*,
	lr.Lawyer_Id
FROM dbo.Lawyer AS lw LEFT JOIN dbo.LawyerReview AS lr ON 
lw.id = lr.Lawyer_Id 
WHERE lr.Lawyer_Id IS NULL;

-- 18.	Prikazati sledece kolone iz tabele [LawyerReview]: Id, Lawyer.FirstName, Lawyer.LastName, JurisdictionName koji se odnose na 2020 I 2018 godinu.

SELECT
	lr.Id,
	lw.FirstName,
	lw.LastName,
	l.[Name] AS 'JurisdictionName',
	lr.CreatedOn
FROM dbo.LawyerReview AS lr INNER JOIN dbo.Lawyer AS lw
ON lr.Lawyer_Id = lw.Id INNER JOIN dbo.Jurisdiction AS j
ON lr.Jurisdiction_Id = j.Id INNER JOIN dbo.[Lookup] AS l ON
j.Id = l.Id
WHERE YEAR(lr.CreatedOn) = 2018 OR YEAR(lr.CreatedOn) = 2020;

-- 19.	Prikazati sledece kolone iz tabele [PracticeAreaLawyer]: 
-- Sledece podatke iz tabele lawyer: FirstName, LastName, Email, Address, JobPosition. Sledeci podatak iz tabele PracticeArea: Name

SELECT
	l.FirstName,
	l.LastName,
	l.Email,
	'Line 1: ' + addr.Line1 + ' Line 2: ' + addr.Line2 + ' Line 3: ' + addr.Line3 + ' POBox: ' + addr.POBox + ' Country: ' + c.[Name]
	AS 'Address',
	l.JobPosition,
	Lk.[Name] AS 'PracticeArea'
FROM dbo.PracticeAreaLawyer AS pal	INNER JOIN dbo.Lawyer AS l
ON pal.Lawyer_Id = l.Id INNER JOIN dbo.PracticeArea AS pa ON
pal.PracticeArea_Id = pa.Id INNER JOIN dbo.[Lookup] AS lk ON
pa.Id = lk.Id  INNER JOIN dbo.[Address] AS addr ON
l.Address_Id = addr.Id INNER JOIN dbo.Country AS c ON
addr.Country_Id = c.Id;

-- 20.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Expert consultant

SELECT
	lw.*,
	lk.[Name] AS 'Ranking Tier'
FROM dbo.LawyerRanking AS lr INNER JOIN dbo.Lawyer AS lw
ON lr.Lawyer_Id = lw.Id INNER JOIN dbo.LawyerTier AS lt
ON lr.Tier_Id = lt.Id INNER JOIN dbo.[Lookup] AS lk
ON lt.Id = lk.Id
WHERE lk.[Name] = 'Expert consultant';

-- 21.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji imaju Ranking Tier: Rising star partner

SELECT
	lw.*,
	lk.[Name] AS 'Ranking Tier'
FROM dbo.LawyerRanking AS lr INNER JOIN dbo.Lawyer AS lw
ON lr.Lawyer_Id = lw.Id INNER JOIN dbo.LawyerTier AS lt
ON lr.Tier_Id = lt.Id INNER JOIN dbo.[Lookup] AS lk
ON lt.Id = lk.Id
WHERE lk.[Name] = 'Rising star partner';

-- 22.	Prikazati sve laywer-e iz tabele [LawyerRanking] koji nemaju Ranking Tier: Women Leaders

SELECT
	lw.*,
	lk.[Name] AS 'Ranking Tier'
FROM dbo.LawyerRanking AS lr INNER JOIN dbo.Lawyer AS lw
ON lr.Lawyer_Id = lw.Id INNER JOIN dbo.LawyerTier AS lt
ON lr.Tier_Id = lt.Id INNER JOIN dbo.[Lookup] AS lk
ON lt.Id = lk.Id
WHERE lk.[Name] <> 'Women Leaders';

-- 23.	Prikazati sve laywer-r koji nemaju Ranking uopste

SELECT
	lw.*,
	lr.Lawyer_Id
FROM dbo.Lawyer AS lw LEFT JOIN dbo.LawyerRanking AS lr ON
lw.Id = lr.Lawyer_Id 
WHERE lr.Lawyer_Id IS NULL; 

-- 24.	Prikazati sledece kolone iz tabele [RankingTierFirm]: Firm.Id, Firm.Name, Jurisdiction.Name, Period, PracticeArea, Tier.Name

SELECT
	f.Id,
	f.[Name],
	lk2.[Name] AS 'Jurisdiction',
	p.[Year] AS 'Period',
	lk3.[Name] AS 'PracticeArea',
	lk.[Name] AS 'Tier'
FROM dbo.RankingTierFirm AS rtf LEFT JOIN dbo.Firm AS f ON
rtf.Firm_Id = f.Id LEFT JOIN  dbo.FirmTier AS ft ON
rtf.Tier_Id = ft.Id LEFT JOIN dbo.[Lookup] AS lk ON
lk.Id = ft.Id LEFT JOIN dbo.FirmRanking AS fr ON
rtf.FirmRanking_Id = fr.Id LEFT JOIN dbo.Jurisdiction AS j ON
fr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk2 ON
j.Id = lk2.Id LEFT JOIN dbo.[Period] AS p ON
fr.Period_Id = p.Id LEFT JOIN dbo.PracticeArea AS pa ON
fr.PracticeArea_Id = pa.Id LEFT JOIN dbo.[Lookup] AS lk3 ON
pa.Id = lk3.Id;

-- 25.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Australia' 
-- (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
 

SELECT
	f.Id,
	f.[Name],
	lk2.[Name] AS 'Jurisdiction.Name',
	lk.[Name] AS 'Tier.Name'
FROM dbo.RankingTierFirm AS rtf LEFT JOIN dbo.Firm AS f ON
rtf.Firm_Id = f.Id LEFT JOIN  dbo.FirmTier AS ft ON
rtf.Tier_Id = ft.Id LEFT JOIN dbo.[Lookup] AS lk ON
lk.Id = ft.Id LEFT JOIN dbo.FirmRanking AS fr ON
rtf.FirmRanking_Id = fr.Id LEFT JOIN dbo.Jurisdiction AS j ON
fr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk2 ON
j.Id = lk2.Id
WHERE lk.[Name] = 'Tier 1' AND lk2.[Name] = 'Australia';

-- 26.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

SELECT
	f.Id,
	f.[Name],
	lk2.[Name] AS 'Jurisdiction',
	lk.[Name] AS 'Tier'
FROM dbo.RankingTierFirm AS rtf LEFT JOIN dbo.Firm AS f ON
rtf.Firm_Id = f.Id LEFT JOIN  dbo.FirmTier AS ft ON
rtf.Tier_Id = ft.Id LEFT JOIN dbo.[Lookup] AS lk ON
lk.Id = ft.Id LEFT JOIN dbo.FirmRanking AS fr ON
rtf.FirmRanking_Id = fr.Id LEFT JOIN dbo.Jurisdiction AS j ON
fr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk2 ON
j.Id = lk2.Id
WHERE lk.[Name] = 'Tier 3' AND lk2.[Name] = 'China';

-- 27.	Prikazati iz samo firme koje imaju ranking 'Tier 3' u jurisdikciji 'China' (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

SELECT
	f.Id,
	f.[Name],
	lk2.[Name] AS 'Jurisdiction',
	lk.[Name] AS 'Tier'
FROM dbo.RankingTierFirm AS rtf LEFT JOIN dbo.Firm AS f ON
rtf.Firm_Id = f.Id LEFT JOIN  dbo.FirmTier AS ft ON
rtf.Tier_Id = ft.Id LEFT JOIN dbo.[Lookup] AS lk ON
lk.Id = ft.Id LEFT JOIN dbo.FirmRanking AS fr ON
rtf.FirmRanking_Id = fr.Id LEFT JOIN dbo.Jurisdiction AS j ON
fr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk2 ON
j.Id = lk2.Id
WHERE lk.[Name] = 'Tier 3' AND lk2.[Name] = 'China';

-- 28.	Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini 
-- (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)

SELECT
	f.Id,
	f.[Name],
	lk2.[Name] AS 'Jurisdiction.Name',
	p.[Year] AS 'Period',
	lk.[Name] AS 'Tier.Name'
FROM dbo.RankingTierFirm AS rtf INNER JOIN dbo.Firm AS f ON
rtf.Firm_Id = f.Id INNER JOIN  dbo.FirmTier AS ft ON
rtf.Tier_Id = ft.Id INNER JOIN dbo.[Lookup] AS lk ON
lk.Id = ft.Id INNER JOIN dbo.FirmRanking AS fr ON
rtf.FirmRanking_Id = fr.Id LEFT JOIN dbo.Jurisdiction AS j ON
fr.Jurisdiction_Id = j.Id LEFT JOIN dbo.[Lookup] AS lk2 ON
j.Id = lk2.Id INNER JOIN dbo.[Period] AS p ON
fr.Period_Id = p.Id 
WHERE lk.[Name] = 'Tier 1' AND lk2.[Name] = 'Barbados' AND p.[Year] = 2014;

