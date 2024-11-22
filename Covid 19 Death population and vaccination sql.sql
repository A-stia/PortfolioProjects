Create view AstiaView As
Select Row_number() over( order by date Asc) As Row_N, Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations 
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date
order by Row_N Desc;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Anas.coviddeaths;

    -- This shows the total number of deaths vs total cases 

SELECT Location, date, total_cases, new_cases, total_deaths, population,(total_deaths/total_cases)*100 As DeathPercen
FROM Anas.coviddeaths
Where Location like '%state%'
And continent is not null;

		
-- This shows the total number of deaths vs total Population

SELECT Location, date, total_cases, new_cases, total_deaths, population,Round((total_cases/Population)*100,0) As PercenPopulation
FROM Anas.coviddeaths
Where Location like '%state%'
And continent is not null;

-- looking at countries with highest infection compare to the population 
SELECT Location, date, MAX(total_cases) HighestInfection, new_cases, total_deaths, population,Round(MAx(total_cases/Population)*100,0) As HighestInfected
FROM Anas.coviddeaths
Where Location like '%state%'
And continent is not null
Group by Location, date,new_cases, total_deaths, population
Order by HighestInfected Desc;
-- showing country with highes death count per population


SELECT Location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathcount
FROM 
    Anas.coviddeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    Location
ORDER BY 
    TotalDeathcount DESC;
    
SELECT continent,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathcount
FROM 
    Anas.coviddeaths
WHERE 
    Continent IS not NULL
GROUP BY 
    continent
ORDER BY 
    TotalDeathcount DESC;
    
-- Global number 
SELECT Location, date, Sum(total_cases), new_cases, sum(CAST(total_deaths AS UNSIGNED)) As TotalDeath, population,(total_deaths/total_cases)*100 As DeathPercen
FROM Anas.coviddeaths
Where Location like '%state%'
And continent is not null
GROUP BY  Location, date,new_cases,population;

SELECT 
SUM(total_cases) AS TotalCases, 
    SUM(CAST(total_deaths AS UNSIGNED)) AS TotalDeath, 
    (SUM(CAST(total_deaths AS UNSIGNED)) / SUM(total_cases)) * 100 AS DeathPercen
FROM 
    Anas.coviddeaths
WHERE continent is NOT NUll;

SELECT *
FROM Anas.coviddeaths As Dea
inner Join Anas.covidvaccinations AS Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

-- Looking at total population Vs vacination 
Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;
-- I can use UNSIGNED or convert for my cast 
Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,
sum(cast(Vac.new_vaccinations as UNSIGNED)) over(Partition by Location)
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,
sum(cast(Vac.new_vaccinations as UNSIGNED)) over(Partition by Location order by Dea.Location, Dea.date) as Rolling_Over_Population
-- We cannot call a field we just name a good option is to use CTE
-- ,(Rolling_Over_Population/Population)*100
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

-- Aggreagte Over(Partition by ...) 
Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations, Avg(Dea.population)
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date
Group by Dea.continent, Dea.Location, Dea.date,Vac.new_vaccinations;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations, Avg(Dea.population) over()
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations, Sum(Dea.population) over(partition by continent)
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

/* Row_Number () Over(Partition by ....) "If we use ROW_NUMBER(), it will assign numbers sequentially, such as 1, 2, 3, 4, 5, and so on, within each partition. 
However, if the query includes conditions or joins that filter out certain rows, some numbers might appear to be skipped in the result set because those rows were excluded before the numbering was applied." 
*/

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,
Row_number() over(Partition by Dea.continent)
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

Select Row_number() over( order by date Asc),Avg(Dea.population) over(order by population Desc) As Row_N, Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations 
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date
order by Row_N Desc;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,Avg(Dea.population) over(Partition by Continent),
Row_number() over(Partition by Dea.population) As Row_num,
Rank() over(Partition by Dea.population) As Rank_number,
Dense_Rank() over(Partition by Dea.population) As Dense_Rk
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,Avg(Dea.population) over(Partition by Continent),
Row_number() over(Partition by Dea.population) As Row_num,
Rank() over(Partition by Dea.population) As Rank_number,
Dense_Rank() over(Partition by Dea.population) As Dense_Rk
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

Select v.*,
Max(population) over(partition by continent) as Max_population
From Anas.coviddeaths as V;

Select v.*,
lag (population) over(partition by location order by date) as Prev_population
From Anas.coviddeaths as V;

Select v.*,
CASE when Population > lag (population, 2,0) over(partition by location order by date) then  'Higher than previous population'
 when Population = lag (population, 2,0) over(partition by location order by date) then  'eqal to previous population'
 when Population < lag (population, 2,0) over(partition by location order by date) then  'less than previous population'
 end Populaton_range
From Anas.coviddeaths as V;

Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,Avg(Dea.population) over(Partition by Continent),
Row_number() over(Partition by Dea.population) As Row_num,
Rank() over(Partition by Dea.population) As Rank_number,
Dense_Rank() over(Partition by Dea.population) As Dense_Rk,
Lag(Population) over(Partition by vac.location) As Rank_number,
Lead(Population) over(Partition by vac.location) As Rank_number
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;

-- The second on my qeury was 30sec session  and my query was returning Error Code: 2013. Lost connection to MySQL server during query	30.002 sec 
-- I had to fix it and refresh to allow me run the below query 
SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;
SET SESSION wait_timeout = 600;



-- Date_Difference
SELECT 
    Dea.continent,
    Dea.Location,
    Dea.date,
    Vac.new_vaccinations,
    DATEDIFF(Dea.date, Vac.date) AS Date_Interval,
    AVG(Dea.population) OVER (PARTITION BY Dea.Continent) AS Avg_Population,
    ROW_NUMBER() OVER (PARTITION BY Dea.population) AS Row_num,
    RANK() OVER (PARTITION BY Dea.population) AS Rank_number,
    DENSE_RANK() OVER (PARTITION BY Dea.population) AS Dense_Rk,
    LAG(Dea.population) OVER (PARTITION BY Vac.location) AS Previous_Population,
    LEAD(Dea.population) OVER (PARTITION BY Vac.location) AS Next_Population
FROM 
    Anas.coviddeaths AS Dea
JOIN 
    Anas.covidvaccinations AS Vac
ON 
    Dea.continent = Vac.continent    
    AND Dea.date = Vac.date;
    
    -- Window function with Where Case 
    SELECT 
    Dea.continent,
    Dea.Location,
    Dea.date,
    Vac.new_vaccinations,
    -- Average population by continent
    AVG(Dea.population) OVER (PARTITION BY Dea.continent) AS Avg_Population_By_Continent,
    -- Row number within each population group
    ROW_NUMBER() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Row_num,
    -- Rank within each population group
    RANK() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Rank_number,
    -- Dense rank within each population group
    DENSE_RANK() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Dense_Rk,
    -- Population interval comparison using LAG and LEAD;
    CASE 
        WHEN Dea.population > LAG(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'High_population'
        WHEN Dea.population < LEAD(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'Lower_population'
        WHEN Dea.population = LEAD(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'Equal'
    END AS Population_interval
FROM 
    Anas.coviddeaths AS Dea
JOIN 
    Anas.covidvaccinations AS Vac
ON 
    Dea.continent = Vac.continent
    AND Dea.date = Vac.date;
    
Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,
--Avg(Dea.population) over(Partition by Continent),
Row_number() over(Partition by Dea.population) As Row_num,
Rank() over(Partition by Dea.population) As Rank_number,
Dense_Rank() over(Partition by Dea.population) As Dense_Rk,
Case When Dea.population > Lag(Dea.population) over(Partition by vac.location) then 'High_population'
	When Dea.population  < Lead(Dea.population) over(Partition by vac.location) then 'Lower_population'
	When Dea.population = Lead(Dea.population) over(Partition by vac.location) then 'Equal'
	End Populaion_interval
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date;
    
-- We cannot call a field we just name a good option is to use ECT 
-- ,(Rolling_Over_Population/Population)*100
-- With Population vs Vacination 

-- CTE all feild must be the sane in the with, select
With PopvsVas(continent,Location,date,new_vaccinations,population,Rolling_Over_Population)
as
(Select Dea.continent,Dea.Location, Dea.date,Vac.new_vaccinations,population,
sum(cast(Vac.new_vaccinations as UNSIGNED)) over(Partition by Location order by Dea.Location, Dea.date) as Rolling_Over_Population
-- We cannot call a field we just name a good option is to use CTE
-- ,(Rolling_Over_Population/Population)*100
FROM Anas.coviddeaths As Dea
Join Anas.covidvaccinations As Vac
ON Dea.continent = Vac.continent
AND Dea.date = Vac.date)
SELECT *,
(Rolling_Over_Population/population)*100 From PopvsVas;

With PopLaVAc(continent,Location,date,new_vaccinations,Population,Date_Interval,Avg_Population,Row_num,Rank_number,Dense_Rk,Previous_Population,Next_Population) as
(SELECT 
    Dea.continent,
    Dea.Location,
    Dea.date,
    Vac.new_vaccinations,
    Population,
    DATEDIFF(Dea.date, Vac.date) AS Date_Interval,
    AVG(Dea.population) OVER (PARTITION BY Dea.Continent) AS Avg_Population,
    ROW_NUMBER() OVER (PARTITION BY Dea.population) AS Row_num,
    RANK() OVER (PARTITION BY Dea.population) AS Rank_number,
    DENSE_RANK() OVER (PARTITION BY Dea.population) AS Dense_Rk,
    LAG(Dea.population) OVER (PARTITION BY Vac.location) AS Previous_Population,
    LEAD(Dea.population) OVER (PARTITION BY Vac.location) AS Next_Population
FROM 
    Anas.coviddeaths AS Dea
JOIN 
    Anas.covidvaccinations AS Vac
ON 
    Dea.continent = Vac.continent    
    AND Dea.date = Vac.date)
    Select *,Round((Avg_Population/Population),1)*100 as Avg_Popp
    from PopLaVAc; 


SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;
SET SESSION wait_timeout = 600;

Drop table Duplicate_Table_PopvsVAc;

With PopLaVAc 
as 
(SELECT 
    Dea.continent,
    Dea.Location,
    Dea.date,
    Vac.new_vaccinations,
    Population,
    DATEDIFF(Dea.date, Vac.date) AS Date_Interval,
    AVG(Dea.population) OVER (PARTITION BY Dea.Continent) AS Avg_Population,
    ROW_NUMBER() OVER (PARTITION BY Dea.population) AS Row_num,
    RANK() OVER (PARTITION BY Dea.population) AS Rank_number,
    DENSE_RANK() OVER (PARTITION BY Dea.population) AS Dense_Rk,
    LAG(Dea.population) OVER (PARTITION BY Vac.location) AS Previous_Population,
    LEAD(Dea.population) OVER (PARTITION BY Vac.location) AS Next_Population
FROM 
    Anas.coviddeaths AS Dea
JOIN 
    Anas.covidvaccinations AS Vac
ON 
    Dea.continent = Vac.continent    
    AND Dea.date = Vac.date)
   
Select Date_Interval,Avg_Population
    from PopLaVAc; 

Create view WidPopVsWit as 
    SELECT 
    Dea.continent,
    Dea.Location,
    Dea.date,
    Vac.new_vaccinations,
    -- Average population by continent
    AVG(Dea.population) OVER (PARTITION BY Dea.continent) AS Avg_Population_By_Continent,
    -- Row number within each population group
    ROW_NUMBER() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Row_num,
    -- Rank within each population group
    RANK() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Rank_number,
    -- Dense rank within each population group
    DENSE_RANK() OVER (PARTITION BY Dea.population ORDER BY Dea.date) AS Dense_Rk,
    -- Population interval comparison using LAG and LEAD;
    CASE 
        WHEN Dea.population > LAG(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'High_population'
        WHEN Dea.population < LEAD(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'Lower_population'
        WHEN Dea.population = LEAD(Dea.population) OVER (PARTITION BY Dea.population ORDER BY Dea.date) THEN 'Equal'
    END AS Population_interval
FROM 
    Anas.coviddeaths AS Dea
JOIN 
    Anas.covidvaccinations AS Vac
ON 
    Dea.continent = Vac.continent
    AND Dea.date = Vac.date;
    
SELECT * 
FROM WidPopVsWit


