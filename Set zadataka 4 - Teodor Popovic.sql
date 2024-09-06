--SQL Group upit (shvatanje agregacije, shvatanje agregatnih funkcija COUNT(), SUM(), MIN(), MAX(),  AVERAGE() - shvatanje HAVING funkcije nad agregacionim setom);

--1.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za svaku firmu

SELECT
	firm.Id,
	firm.[Name],
	COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
firm.Id = paf.Firm_Id
GROUP BY firm.Id, firm.[Name];

--2.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju vise od 5 povezanih practice area-a

SELECT
	firm.Id,
	firm.[Name],
	COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
firm.Id = paf.Firm_Id
GROUP BY firm.Id, firm.[Name]
HAVING COUNT(*) > 5;

--3.	Prikazati sledece podatke iz tabele Firm: Firm.Id, Firm.Name, Ukupan broj povezanih practice area-a (tabela [PracticeAreaFirm]) za sve firme koje imaju manje od 5 povezanih practice area-a

SELECT
	firm.Id,
	firm.[Name],
	COUNT(*) AS 'PracticeAreaFirm_CountByFirm'
FROM dbo.Firm AS firm LEFT JOIN dbo.PracticeAreaFirm AS paf ON
firm.Id = paf.Firm_Id
GROUP BY firm.Id, firm.[Name]
HAVING COUNT(*) < 5;

--4.	Prikazati sledece podatke iz tabele Lawyer L: L.Id, L.FirstName, L.LastName, Ukupan broj povezanih practice area-a (tabela [PracticeAreaLawyer]) za svakog lawyer-a

SELECT
	l.Id,
	l.FirstName,
	l.LastName,
	COUNT(*) AS 'PracticeAreaLawyer_CountByLawyer'
FROM dbo.Lawyer AS l LEFT JOIN dbo.PracticeAreaLawyer AS pal ON
l.Id = pal.Lawyer_Id
GROUP BY l.Id, l.FirstName, l.LastName;

--5.	Prikazati 10 najzastupljenijih Practice Area koje su vezane za ceo set firmi.

SELECT TOP(10)
	[lookup].[Name],
	COUNT(pa.Id) AS 'PracticeAreaCount'
FROM dbo.PracticeAreaFirm AS paf INNER JOIN dbo.PracticeArea AS pa ON
paf.PracticeArea_Id = pa.Id INNER JOIN dbo.[Lookup] AS [lookup] ON
pa.Id = [lookup].Id INNER JOIN dbo.Firm AS firm ON
paf.Firm_Id = firm.Id
GROUP BY [lookup].[Name]
ORDER BY [PracticeAreaCount] DESC;

--6.	Prikazati 20 najzastupljenijih Practice Area koje su vezane za ceo set lawyer-a.

SELECT TOP(20)
	[lookup].[Name],
	COUNT(pa.Id) AS 'PracticeAreaCount'
FROM dbo.PracticeAreaLawyer AS pal INNER JOIN dbo.PracticeArea AS pa ON
pal.PracticeArea_Id = pa.Id INNER JOIN dbo.[Lookup] AS [lookup] ON
pa.Id = [lookup].Id INNER JOIN dbo.Lawyer AS law ON
pal.Lawyer_Id = law.Id
GROUP BY [lookup].[Name]
ORDER BY [PracticeAreaCount] DESC;

--7.	Prikazati 15 najmanje zastupljenih (ali ne I nezastupljenih) Practice Area koje su vezane za ceo set firmi.

SELECT TOP(15)
	[lookup].[Name],
	COUNT(pa.Id) AS 'PracticeAreaCount'
FROM dbo.PracticeAreaFirm AS paf RIGHT JOIN dbo.PracticeArea AS pa ON
paf.PracticeArea_Id = pa.Id RIGHT JOIN dbo.[Lookup] AS [lookup] ON
pa.Id = [lookup].Id RIGHT JOIN dbo.Firm AS firm ON
paf.Firm_Id = firm.Id
GROUP BY [lookup].[Name]
ORDER BY [PracticeAreaCount];

--8.	Prikazati spisak zemalja sa ukupnim brojem povezanih firmi

SELECT 
	c.[Name],
	COUNT(firm.Id) AS 'RelatedFirmCount_ByCountry'
FROM dbo.Firm AS firm INNER JOIN dbo.Country AS c ON
firm.Country_Id = c.Id
GROUP BY c.[Name]; 

--9.	Prikazati spisak zemalja sa sledecim kolona: Country.Name, Broj povezanih firmi, Lista povezanih firmi odvojenih zarezom (u jednoj celiji)

SELECT 
	c.[Name],	
	COUNT(firm.Id) AS 'RelatedFirmCount_ByCountry',
	STRING_AGG(CONVERT(NVARCHAR(MAX),firm.[Name]),',') AS 'ListOfRelatedFirms'
FROM dbo.Firm AS firm INNER JOIN dbo.Country AS c ON
firm.Country_Id = c.Id
GROUP BY c.[Name];

--10.	Prikazati koliko svaki sponsor (Sponsor_Id) ima vezanih artikala ukupno. Izvestaj treba da ima sledece kolone: Sponsor_Id, Naziv Sponsora, Broj vezanih artikala, Lista coma separated Article id-jeva (u jednoj celiji)

SELECT
	article.Sponsor_Id,
	sponsor.[Name],
	COUNT(*) AS 'CountOfRelatedArticles',
	STRING_AGG(CONVERT(NVARCHAR(MAX), article.Id),',') AS 'ListOfRelatedArticlesIds'
FROM dbo.Article AS article INNER JOIN dbo.Firm AS sponsor ON
article.Sponsor_Id = sponsor.Id
GROUP BY article.Sponsor_Id, sponsor.[Name];

--11.	Napraviti izvestaj koji ce da ima sledece kolone: Deal.Year, Deal.Month, ukupan broj deal-ova, ukupan iznos deal-ova (DollarValue), prosecnu vrednost deal-ova (DollarValue), minimalnu vrednost deal-ova (DollarValue), maximalnu vrednost deal-ova (DollarValue) za sve Deal-ove koji imaju EntityStatus = 3

SELECT
	Deal.[Year],
	Deal.[Month],
	COUNT(*) AS 'TotalNumberOfDeals',
	SUM(DollarValue) AS 'TotalDealValue',
	AVG(DollarValue) AS 'AverageDealValue',
	MIN(DollarValue) AS 'MinimalDealValue',
	MAX(DollarValue) AS 'MaximalDealValue'
FROM dbo.Deal
WHERE EntityStatus = 3
GROUP BY Deal.[Year], Deal.[Month];

--12.	Napraviti izvestaj koji ce da prikaze sledece vrednosti: Deal.Id, Deal.Title, sve povezane PracticeArea-a, sve povezane Lawyer-e s, sve povezane jurisdikcije, sve povezane DealGoverningLaw

SELECT
	deal.Id,
	deal.Title,
	STRING_AGG(CONVERT(NVARCHAR(MAX), [Lookup].[Name]),',') AS 'AllPracticeAreas',
	STRING_AGG(CONVERT(NVARCHAR(MAX), lawyer.FirstName + ' ' + lawyer.LastName),',') AS 'AllLawyers',
	STRING_AGG(CONVERT(NVARCHAR(MAX), [Lookup].[Name]),',') AS 'AllJurisdictions',
	STRING_AGG(CONVERT(NVARCHAR(MAX), GoverningLaw.Title),',') AS 'AllGoverningLaws'
FROM dbo.Deal AS deal INNER JOIN dbo.DealPracticeArea ON
deal.Id = DealPracticeArea.Deal_Id INNER JOIN dbo.PracticeArea AS practiceArea ON
DealPracticeArea.PracticeArea_Id = practiceArea.Id INNER JOIN dbo.[Lookup] AS [lookup] ON
practiceArea.Id = [lookup].Id INNER JOIN dbo.DealLawyer ON
DealLawyer.Deal_Id = deal.Id INNER JOIN dbo.Lawyer AS lawyer ON
DealLawyer.Lawyer_Id = lawyer.Id INNER JOIN dbo.DealJurisdiction ON
deal.Id = DealJurisdiction.Deal_Id INNER JOIN dbo.Jurisdiction ON
DealJurisdiction.Jurisdiction_Id = Jurisdiction.Id INNER JOIN dbo.[Lookup] AS [lookupJurisdiction] ON
Jurisdiction.Id = [lookupJurisdiction].Id INNER JOIN dbo.DealGoverningLaw ON
deal.Id = DealGoverningLaw.Deal_Id INNER JOIN dbo.GoverningLaw ON
DealGoverningLaw.GoverningLaw_Id = GoverningLaw.Id
GROUP BY deal.Id, deal.Title;

--13.	Napraviti izvestaj koji ce da pokaze sve Deal-ove (Deal.Id, Deal.Title) koji imaju Value veci od ukupne prosecne vrednosti svih Deal-ova iz tabele koji imaju Deal veci od 0.

SELECT
	Deal.Id,
	Deal.Title
FROM dbo.Deal
WHERE Deal.[Value] > (SELECT AVG(Deal.[Value]) FROM dbo.Deal WHERE [Value] > 0);  

--14.	Napraviti izvestaj koji ce da prikaze broj Deal-ova napravljenih na odredjeni dan (koristiti polje [CreatedOn]). 
--Izvestaj treba da ima sledece kolone: CreatedOn, CountDeals. Izvestaj treba da bude sortiran tako da pokaze prvo dane sa najvise napravljenih deal-ova

SELECT
	Deal.CreatedOn,
	COUNT(*) AS 'CountDeals'
FROM dbo.Deal
GROUP BY Deal.CreatedOn
ORDER BY [CountDeals] DESC;

--15.	Napraviti izvestaj koji ce da prikaze ko je od editora uneo u sistem najvise deal-ova, kako bi 3 editora sa najvise deal-ova dobila bonus.

SELECT -- TOP(3)
	[user].Forename AS 'Editor_Forename',
	[user].Surname AS 'Editor_Surname',
	COUNT(*) AS 'Number_Of_Deals'
FROM dbo.Deal AS deal INNER JOIN dbo.[User] AS [user] ON
deal.Editor_Id = [user].Id
GROUP BY [user].Forename, [user].Surname
ORDER BY [Number_Of_Deals] DESC;

--16.	Napraviti izvestaj koji ce da prikaze u svakoj godini ko je od editora napravio najvise izvestaja.

SELECT	
    -- Pokusavao sam sa podupitom ali nije islo za Year
	Editor.Forename + ' ' + Editor.Surname AS 'Editor',	
	COUNT(*) AS 'NumberOfDeals'
FROM dbo.Deal INNER JOIN dbo.[User] AS Editor ON
Deal.Editor_Id = Editor.Id
WHERE [Year] IS NOT NULL
GROUP BY Editor.Forename, Editor.Surname
ORDER BY [NumberOfDeals] DESC 

--17.	Napraviti izvestaj koji ce da izvuce po Currency-ju koliko svaki Currency ima vezanih Deal-ova. 
-- Izvestaj treba da ima sledece kolone: CurrencyId, CurrencyName, Broj vezanih deal-ova, 
-- Deals (comma separated list of deal ids). Izvestaj treba da bude sortiran u opadajucem redosledu po broju povezanih Currency-ja.

SELECT
	currency.Id AS 'CurrencyId',
	currencyInfo.[Name] AS 'CurrencyName',
	COUNT(*) AS 'NumberOfRelatedDeals',
	STRING_AGG(CONVERT(NVARCHAR(MAX), deal.Id),',') AS 'RelatedDeals'
FROM dbo.Deal AS deal INNER JOIN dbo.Currency AS currency ON
deal.Currency_Id = currency.Id INNER JOIN dbo.[Lookup] AS currencyInfo ON
currency.Id = currencyInfo.Id
GROUP BY currency.Id, currencyInfo.[Name]
ORDER BY [NumberOfRelatedDeals] DESC;
