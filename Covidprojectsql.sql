--select *
--from Projectsql..coviddeath 
--where continent is not null
--order by 4 asc

--select location, date, total_cases, new_cases, total_deaths, population
--from Projectsql..coviddeath
--order by 1,2

--Looking at total cases vs total death
----Shows likelyhood of dieing if you contact covid in nigeria
--SELECT 
--    location, 
--    COUNT( distinct total_cases) AS Totalcasescount, 
--    date, 
--    total_cases, 
--    total_deaths, 
--    (total_deaths / total_cases) * 100 AS DeathPercentage
--FROM 
--    Projectsql..coviddeath
--	Where location like '%Nigeria%'
--		--Where location = 'Nigeria'
--GROUP BY
--    location, date, total_cases, total_deaths
--ORDER BY 
--    location, Totalcasescount;



	--Looking at total cases and population
	--Shows what percentage of the population got covid
--	SELECT 
--    location, 
--    COUNT( distinct total_cases) AS Totalcasescount, 
--    date, 
--    total_cases, 
--	population,
--    (total_cases / population) * 100 AS populationPercentage
--FROM 
--    Projectsql..coviddeath
--	--Where location like '%Nigeria%'
--		--Where location = 'Nigeria'
--GROUP BY
--    location, date, total_cases, population
--ORDER BY 
--    location, Totalcasescount;

	--Looking at countries with highest infection rate compared to population
	--select 
	--  location, max(total_cases) as HighestnoCases, population, Max(total_cases / population) * 100 AS populationPercentageInfected
	--from
	--  Projectsql..coviddeath
	----where location = 'Nigeria'
	--group by  
	--   location, population
	--order
	--   by location ,HighestnoCases


	---Showing countries with the highest death count in a location per cases
--	   SELECT 
--    location,
--   MAX(total_deaths)as HighestDeathcount
--   from
--    Projectsql..coviddeath
--	--Where location like '%Nigeria%'
--		Where
--	continent is not null
--GROUP BY
--   location
--ORDER BY 
--     HighestDeathcount;



----Let breakthings down by continent
--SELECT 
--    continent,
--    MAX(total_deaths) as Totaldeaths,
--    SUM(MAX(total_deaths)) OVER() as TotalDeathsAcrossContinents
--FROM 
--    Projectsql..coviddeath
--WHERE 
--    continent IS NOT NULL
--GROUP BY 
--    continent
--ORDER BY 
--    continent;

--Global deaths 

--Select sum(new_cases) as totalcases, sum(new_deaths) as total_death , sum(new_deaths)/sum(new_cases)*100 as Deathpercentage

--from Projectsql..coviddeath
--where continent is not null



select
dea.continent, 
dea.location,
dea.date,
dea.population, 
vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date )as Rollingpeople vaccinated
from 
     Projectsql..coviddeath as dea join Projectsql..covidvaccination as vacc

on 
   dea.location = vacc.location and
   dea.date = vacc.date
   where dea.continent is not null  
   order by 2,3 


with Peoplevaccinated(continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated) 
as
 (  
select
dea.continent, 
dea.location,
dea.date,
dea.population, 
vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over(partition by dea.location order by  dea.date asc )as Rollingpeoplevaccinated
from 
     Projectsql..coviddeath as dea join Projectsql..covidvaccination as vacc

on 
   dea.location = vacc.location and
   dea.date = vacc.date
 where dea.continent is not null
   --order by 2,3 
   )
   select * ,(Rollingpeoplevaccinated/population)*100 as Rollingpercentage
   from Peoplevaccinated


   --Creating view to store data for later visaualization
   create view Nigeriacovid as
   SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM 
    Projectsql..coviddeath
	Where location like '%Nigeria%'
		--Where location = 'Nigeria'
GROUP BY
    location, date, total_cases, total_deaths



	create view covidpercentage	as--Shows what percentage of the population got covid
	SELECT 
    location, 
    COUNT( distinct total_cases) AS Totalcasescount, 
    date, 
    total_cases, 
	population,
    (total_cases / population) * 100 AS populationPercentage
FROM 
    Projectsql..coviddeath
	--Where location like '%Nigeria%'
		--Where location = 'Nigeria'
GROUP BY
    location, date, total_cases, population

		--Looking at countries with highest infection rate compared to population
		create view countryInfectionPopulation as
	select 
	  location, max(total_cases) as HighestnoCases, population, Max(total_cases / population) * 100 AS populationPercentageInfected
	from
	  Projectsql..coviddeath
	--where location = 'Nigeria'
	group by  
	   location, population

	   
	---Showing countries with the highest death count in a location per cases
	create view Infectiondeathpercase as
	   SELECT 
    location,
   MAX(total_deaths)as HighestDeathcount
   from
    Projectsql..coviddeath
	--Where location like '%Nigeria%'
		Where
	continent is not null
GROUP BY
   location


   ----Let breakthings down by continent
   create view maximumdeathbycontinent as
SELECT 
    continent,
    MAX(total_deaths) as Totaldeaths

FROM 
    Projectsql..coviddeath
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent


--Global deaths 
create view tottaldeathpercentage as
Select sum(new_cases) as totalcases, sum(new_deaths) as total_death , sum(new_deaths)/sum(new_cases)*100 as Deathpercentage

from Projectsql..coviddeath
where continent is not null

create view Populationvaccinated as

with Peoplevaccinated(continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated) 
as
 (  
select
dea.continent, 
dea.location,
dea.date,
dea.population, 
vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over(partition by dea.location order by  dea.date asc )as Rollingpeoplevaccinated
from 
     Projectsql..coviddeath as dea join Projectsql..covidvaccination as vacc

on 
   dea.location = vacc.location and
   dea.date = vacc.date
 where dea.continent is not null
   --order by 2,3 
   )
   select * ,(Rollingpeoplevaccinated/population)*100 as Rollingpercentage
   from Peoplevaccinated








    




