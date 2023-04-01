SELECT 
    *
FROM
    covid19.`covid 19 dealths`
    WHERE continent is not null
ORDER BY 3,4;
SELECT * FROM covid19.`covid vaccination`
WHERE continent is not null
ORDER BY 3,4;
SELECT location,date, total_cases,new_cases,total_deaths,population
FROM covid19.`covid 19 dealths`
WHERE continent is not null
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid19.`covid 19 dealths`
ORDER BY 1,2;

SELECT location, date, total_cases, population, (total_deaths/population)*100 AS pencentage_population_infected
FROM covid19.`covid 19 dealths`
ORDER BY 1,2;

--Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as highest_infection_count , MAX((total_deaths/population))*100 AS percentage_population_infected
FROM covid19.`covid 19 dealths`
GROUP BY population,location
ORDER BY percentage_population_infected desc;

SELECT location, MAX(total_deaths) as total_death_count
FROM covid19.`covid 19 dealths`
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count desc;

SELECT  continent, MAX(total_deaths) as total_death_count
FROM covid19.`covid 19 dealths`
WHERE continent is null
GROUP BY continent
ORDER BY total_death_count desc;

SELECT date, SUM(new_cases),SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as  death_percentage
FROM covid19.`covid 19 dealths`
WHERE continent is not null
GROUP BY date
 ORDER BY 1,2;
 
 -- Looking at total vaccination vs population
 
 SELECT dea.continent, dea.population,dea.location, dea.date,vac.new_vaccinations
 ,SUM(vac.new_vaccinations ) OVER (partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
 FROM covid19.`covid 19 dealths`dea
JOIN covid19.`covid vaccination`vac
on dea.location = vac.location
and dea.date=  vac.date
where dea.continent is not null
order by 2,3;
-- USE CTE 

WITH PopvsVac(continent, population,location,date,new_vaccination,rolling_people_vaccinated)
as 
(
SELECT dea.continent, dea.population,dea.location, dea.date,vac.new_vaccinations
 ,SUM(vac.new_vaccinations ) OVER (partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
 FROM covid19.`covid 19 dealths`dea
JOIN covid19.`covid vaccination`vac
on dea.location = vac.location
and dea.date=  vac.date
where dea.continent is not null
)
SELECT *, (rolling_people_vaccinated/population)*100 
FROM PopvsVac;
-- TEMP TABLE


CREATE TABLE percent_population_vaccinated
(
Continent varchar(255),
population numeric,
location varchar(255),
date datetime,
new_vaccination numeric,
rolling_people_vaccinated numeric
)

INSERT INTO percent_population_vaccinated
WITH PopvsVac(continent, population,location,date,new_vaccination,rolling_people_vaccinated)
as 
(
SELECT dea.continent, dea.population,dea.location, dea.date,vac.new_vaccinations
 ,SUM(vac.new_vaccinations ) OVER (partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
 FROM covid19.`covid 19 dealths`dea
JOIN covid19.`covid vaccination`vac
on dea.location = vac.location
and dea.date=  vac.date
where dea.continent is not null
)
SELECT *, (rolling_people_vaccinated/population)*100 
FROM percent_population_vaccinated;

-- creating view to store data for later visualization

CREATE VIEW #percentpopulationvaccinated as 
(
SELECT dea.continent, dea.population,dea.location, dea.date,vac.new_vaccinations
,SUM(vac.new_vaccinations ) OVER (partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM covid19.`covid 19 dealths`dea
JOIN covid19.`covid vaccination`vac
on dea.location = vac.location
and dea.date=  vac.date
where dea.continent is not null
);
SELECT *
FROM percent_population_vaccinated;




 
 
 
 
 



