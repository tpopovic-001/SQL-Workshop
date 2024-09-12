--1.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 1 sa nazivom [vFirmPracticeAreasStats_VaseImePrezime]. 
--Napraviti select iz tako napravljenog view-a. Rezultate view-a prepuniti u #temp tabelu. Napraviti select iz tako napravljene #temp tabele. 
--Obrisati temp tabelu.

CREATE VIEW [dbo].[vFirmPracticeAreasStats_TeodorPopovic] AS 
SELECT
	firm.Id,
	firm.[Name],
	COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
firm.Id = paf.Firm_Id
GROUP BY firm.Id, firm.[Name];

SELECT * FROM [dbo].[vFirmPracticeAreasStats_TeodorPopovic];

SELECT 
	* 
INTO #tempFirmPracticeAreaStats
FROM [dbo].[vFirmPracticeAreasStats_TeodorPopovic]

SELECT * FROM #tempFirmPracticeAreaStats

DROP TABLE #tempFirmPracticeAreaStats

--2.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 10 sa nazivom [vCountryRelatedFirms_VaseImePrezime]. 
--Napraviti select iz tako napravljenog view-a. Napraviti select is napravljenog view-a, za sve zemlje koje imaju vise od 1000 povezanih firmi. 
--Takav select prepuniti u #temp tabelu. Obrisati temp tabelu.

CREATE VIEW [dbo].[vCountryRelatedFirms_TeodorPopovic] AS
SELECT 
	c.[Name],	
	COUNT(firm.Id) AS 'RelatedFirmCount_ByCountry',
	STRING_AGG(CONVERT(NVARCHAR(MAX),firm.[Name]),',') AS 'ListOfRelatedFirms'
FROM dbo.Firm AS firm INNER JOIN dbo.Country AS c ON
firm.Country_Id = c.Id
GROUP BY c.[Name];

SELECT * FROM [dbo].[vCountryRelatedFirms_TeodorPopovic];

SELECT * 
INTO #tempCountryRelatedFirms
FROM [dbo].[vCountryRelatedFirms_TeodorPopovic] WHERE RelatedFirmCount_ByCountry > 1000;

-- SELECT * FROM  #tempCountryRelatedFirms cisto da se vidi sadrzaj temp tabele

DROP TABLE #tempCountryRelatedFirms

--3.	Napraviti kopiju postojeceg view-a [vFirmPracticeAreasStats] sa sledecim nazivom: [vFirmPracticeAreasStats_VaseImePrezime] -- vec ima takav view

CREATE VIEW [dbo].[vFirmPracticeAreasStats_TeodorPopovicCopy] AS
SELECT f.Id, f.[Name], COUNT(*) AS 'Ukupan broj povezanih practice area-a'
FROM Firm f
INNER JOIN PracticeAreaFirm par ON f.Id = par.Firm_Id
GROUP BY f.Id, f.[Name]

--4.	Update-ovati view: [vFirmPracticeAreasStats_VaseImePrezime] - dodati bilo kakvu kolonu, moze I fiksni string, svejedno.

ALTER VIEW [dbo].[vFirmPracticeAreasStats_TeodorPopovicCopy] AS
SELECT f.Id, f.[Name], COUNT(*) AS 'Ukupan broj povezanih practice area-a', STRING_AGG(CONVERT(NVARCHAR(MAX), f.[Description]),',') AS 'Descriptions'
FROM Firm f
INNER JOIN PracticeAreaFirm par ON f.Id = par.Firm_Id
GROUP BY f.Id, f.[Name]

--SELECT * FROM [dbo].[vFirmPracticeAreasStats_TeodorPopovicCopy]

--5.	Napraviti view na osnovu SQL upita iz prethodne vezbe broj 14 sa nazivom [vDealWithValueGreaterThanAverage_VaseImePrezime]. 
-- Tako napravljeni view iskoristiti za novi upit I povezati sa DealLawyer-ima, na nacin da izvestaj ima isti broj redova kao I sam view,
--a lawyer-e zelim da prikazem grupisane po Deal-u {FirstName} {LastName} kao comma separated vrednosti.

CREATE VIEW [dbo].[vDealWithValueGreaterThanAverage_TeodorPopovic] AS
SELECT
	Deal.Id,
	Deal.Title
FROM dbo.Deal
WHERE Deal.[Value] > (SELECT AVG(Deal.[Value]) FROM dbo.Deal WHERE [Value] > 0);

SELECT 
	viewDeal.Id,
	viewDeal.Title,
	STRING_AGG(CONVERT(NVARCHAR(MAX), law.FirstName + ' ' + law.LastName),',') AS 'Lawyer'
FROM [dbo].[vDealWithValueGreaterThanAverage_TeodorPopovic] AS viewDeal
LEFT JOIN ([dbo].[DealLawyer] AS DL INNER JOIN  [dbo].[Lawyer] AS law ON 
DL.Lawyer_Id = law.Id) ON
viewDeal.Id = DL.Deal_Id
GROUP BY viewDeal.Id, viewDeal.Title 

--6.	Napraviti skalarnu funkciju koja spaja dva stringa.

CREATE FUNCTION [dbo].[ConcatenateTwoStrings_TeodorPopovic]
(
	@firstString NVARCHAR(250),
	@secondString NVARCHAR(250)
)
RETURNS NVARCHAR(250) AS
BEGIN
	RETURN CONCAT(@firstString,' ', @secondString);
END

select [dbo].[ConcatenateTwoStrings_TeodorPopovic](N'Teodor',N'Popovic');


--7.	Napraviti skalarnu funkciju ce na dati datetime da dodaje odredjen broj dana I vraca rezultat kao novi datetime.

CREATE FUNCTION [dbo].[CreateNewDatetime_TeodorPopovic]
(
	@Date DATETIME,
	@NumberOfDays INT
)
RETURNS DATETIME AS
BEGIN
	RETURN DATEADD(DAY,@NumberOfDays, @Date);
END

--SELECT [dbo].[CreateNewDatetime_TeodorPopovic](GETDATE(), 2); TEST

--8.	Iskoristiti funkciju koja spaja dva stringa, I izlistati sve lawyer-e iz baze. Izvestaj treba da ima sledece kolone: Lawyer.Id, FirstNameLastName.

SELECT
	Lawyer.Id,
	[dbo].[ConcatenateTwoStrings_TeodorPopovic](Lawyer.FirstName,Lawyer.LastName) AS 'Lawyer'
FROM [dbo].[Lawyer];


--9.	Iskoristiti funkciju iz tacke 8, da se prikazu svi artikli kojima ExpireDate istekao pre nedelju dana.

SELECT
	*
FROM [dbo].[Article] WHERE [ExpireDate] = [dbo].[CreateNewDatetime_TeodorPopovic](current_date,-7); 

--10.	Napraviti tabelarnu funkciju koja vraca sve Practice Area entitete u sledecem obliku: Id, Name

CREATE FUNCTION [dbo].[GetPracticeAreas_TeodorPopovic]()
RETURNS TABLE AS
RETURN
	SELECT
		[Lookup].Id,
		[Lookup].[Name]
	FROM dbo.PracticeArea AS pa LEFT JOIN dbo.[Lookup] AS [lookup] ON
	pa.Id = [lookup].Id

	-- select * from [GetPracticeAreas_TeodorPopovic]()

--11.	Iskoristiti tabelarnu funkciju iz tacke 11 I napraviti izvestaj da se prikazu sve firme koje su vezane za navedenu practice area. 
--Izvestaj treba da ima isto redova kao I funkcija. Firme prikazati kao pipe separated.

SELECT
	fnPracticeArea.Id,
	fnPracticeArea.[Name],
	STRING_AGG(CONVERT(NVARCHAR(MAX), f.[Name]),'|') AS 'Firms'
FROM [dbo].[GetPracticeAreas_TeodorPopovic]() AS fnPracticeArea LEFT JOIN 
dbo.PracticeAreaFirm AS paf ON 
fnPracticeArea.Id = paf.PracticeArea_Id LEFT JOIN dbo.Firm AS f ON
paf.Firm_Id = f.Id
GROUP BY fnPracticeArea.Id, fnPracticeArea.[Name]

--12.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura treba da se zove [spFirmPracticeAreas_VaseImePrezime]

CREATE PROC [dbo].[spFirmPracticeAreas_TeodorPopovic] AS
BEGIN
		SELECT
		firm.Id,
		firm.[Name],
		COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
	FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
	firm.Id = paf.Firm_Id
	GROUP BY firm.Id, firm.[Name];
END

--exec [dbo].[spFirmPracticeAreas_TeodorPopovic]

--13.	Napraviti sp za zadatak broj 1 iz group by unit-a; Procedura rezultate iz query-ja treba da napuni u tabelu [ReportFirmPracticeAreas_VaseImePrezime]. 
--Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. Ukoliko tabela postoji, procedura treba da je obrise I ponovo kreira I napuni podacima

CREATE PROC [dbo].[PopulateTableReportFirmPractice_Areas_TeodorPopovic]
AS
BEGIN
	DROP TABLE IF EXISTS [dbo].[ReportFirmPracticeAreas_TeodorPopovic] 
	SELECT 
		firm.Id,
		firm.[Name],
		COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
	INTO [dbo].[ReportFirmPracticeAreas_TeodorPopovic]
	FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
	firm.Id = paf.Firm_Id
	GROUP BY firm.Id, firm.[Name];
END

exec [dbo].[PopulateTableReportFirmPractice_Areas_TeodorPopovic]

-- select * from [dbo].[ReportFirmPracticeAreas_TeodorPopovic]

--14.	Napraviti sp za zadatak broj 14 iz group by unit-a; Procedura treba da se zove [spDealsGreaterThanAverage_VaseImePrezime]. 
--Procedura treba da rezultate iz tabele napuni u novu tabelu [ReportDealsGreaterThanAverage_VaseImePrezime]. 
--Procedura na pocetku izvrsenja treba da proveri da li tabela vec postoji. Ukoliko tabela postoji, 
--procedura treba da je obrise I ponovo kreira I napuni podacima

CREATE PROC [dbo].[spDealsGreaterThanAverage_TeodorPopovic]
AS
BEGIN
	DROP TABLE IF EXISTS [dbo].[ReportDealsGreaterThanAverage_TeodorPopovic]
	SELECT
		Deal.Id,
		Deal.Title
	INTO [dbo].[ReportDealsGreaterThanAverage_TeodorPopovic]
	FROM dbo.Deal
	WHERE Deal.[Value] > (SELECT AVG(Deal.[Value]) FROM dbo.Deal WHERE [Value] > 0);  
END

exec [dbo].[spDealsGreaterThanAverage_TeodorPopovic]

--select * from [dbo].[ReportDealsGreaterThanAverage_TeodorPopovic]

--15.	Napraviti sp koja ce da prima sledece parametre: DealIds, DealValueFrom, DealValueTo I koja ce da izvuce sve deal-ove (Id, Title, Value) 
-- za listu dostavljenih comma separated deal-ova (DealIds) gde je [Value] izmedju dosavljenih parametara (DealValueFrom AND DealValueTo). 
--Procedura treba da se zove [spDealByIdsAndValueRange_VaseImePrezime]. Napraviti nekoliko poziva store procedure za razlicite vrednosti parametara

--CREATE PROC [dbo].[spDealByIdsAndValueRange_TeodorPopovic]
--(
--	@DealIds VARCHAR(MAX), -- SAMO ZAPOCET PRIMER FUNKCIJA ZA String split iz nekog razloga nije radila pa sam zato preskocio primer
--	@DealValueFrom DECIMAL(10,2),
--	@DealValueTo DECIMAL(10,2)
--)AS
--BEGIN
--	SELECT
--		id,
--		Title,
--		[Value]
--	FROM dbo.Deal AS deal WHERE [Value] BETWEEN @DealValueFrom AND @DealValueTo;

--END


--16.	Napraviti proceduru koja ce da se zove [spPopulateNotExpiredArticles_VaseImePrezime]. 
--Procedura treba da proveri da li postoji tabela [reportNotExpiredArticles_VaseImePrezime]. Ukoliko postoji sp treba da je obrise. 
--Sp treba da napravi upit koji treba da ima sledece kolone: a.Id, a.Title, a.ExpiresIn iz tabele [Article]. 
--ExpiresIn predstavlja broj dana od trenutnog vremena do datuma isteka artikla. 
--Rezultat query-ja treba da napuni tabelu [reportNotExpiredArticles_VaseImePrezime]. 



CREATE PROC [dbo].[spPopulateNotExpiredArticles_TeodorPopovic]
AS
BEGIN
	DROP TABLE IF EXISTS [dbo].[reportNotExpiredArticles_TeodorPopovic]
	SELECT
		a.Id,
		a.Title,
		DATEDIFF(DAY,GETDATE(), a.[ExpireDate]) AS 'ExpiresIn'
		INTO [dbo].[reportNotExpiredArticles_TeodorPopovic]
	FROM dbo.Article AS a WHERE a.[ExpireDate] > GETDATE(); 

END

exec [dbo].[spPopulateNotExpiredArticles_TeodorPopovic]

-- select * from [dbo].[reportNotExpiredArticles_TeodorPopovic]

--17. Napraviti sp koja za izvestaj koji je radjen u jednoj od prethodnih vezbi:
--Prikazati iz samo firme koje imaju ranking 'Tier 1' u jurisdikciji 'Barbados' u 2014. godini (glavne dve tabele - ne I jedine neophodne za ovaj upit: [RankingTierFirm], FirmRanking)
--sp treba da prima sledece parametre (tierName, jurisdictionName, year) I  da uradi istu stvar kao I upit samo koristeci dostavljene parametere. Napraviti nekoliko primera poziva ka takvoj sp.

CREATE PROC [dbo].[GetRankings_TeodorPopovic]
(
	@tierName NVARCHAR(120),
	@JurisdictionName NVARCHAR(120),
	@year INT

)AS
BEGIN
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
	WHERE lk.[Name] = @tierName AND lk2.[Name] = @JurisdictionName AND p.[Year] = @year;
END

exec [dbo].[GetRankings_TeodorPopovic] @tierName = N'Tier 1',@JurisdictionName=N'Albania', @year= 2015;

exec [dbo].[GetRankings_TeodorPopovic] @tierName = N'Tier 2',@JurisdictionName=N'Montenegro', @year= 2017;

exec [dbo].[GetRankings_TeodorPopovic] @tierName = N'Tier 3',@JurisdictionName=N'Canada', @year= 2016;