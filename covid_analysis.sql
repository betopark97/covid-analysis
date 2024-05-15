-- Queries for Exploratory Data Analysis
SELECT * FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Select Data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in South Korea
SELECT
	location
	,date
	,total_cases
	,total_deaths
	,(total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
WHERE location='South Korea' AND continent IS NOT NULL
ORDER BY location, date;

-- Looking at Total Cases vs Population
-- Shows what pecentage of population got Covid
SELECT
	location
	,date
	,total_cases
	,population
	,(total_cases/population)*100 AS infection_percentage
FROM covid_deaths
WHERE location='South Korea' AND continent IS NOT NULL
ORDER BY location, date;

-- Look at Countries with Highest Infection Rate compared to Population
SELECT
	location
	,population
	,MAX(total_cases) AS highest_infection_count
	,MAX((total_cases/population)*100) AS infection_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infection_percentage DESC;

-- Showing Countries with Highest Death Count per Population
SELECT
	location
	,MAX(total_deaths/population) AS death_per_population
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_per_population DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing continents with the highest total death counts
SELECT
	continent
	,SUM(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Showing continents with the highest individual death count
SELECT
	continent
	,MAX(total_deaths) AS highest_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC;

-- GLOBAL NUMBERS (don't know why it doesn't work)
SELECT
	date
	,SUM(new_cases) AS total_new_cases
	,SUM(new_deaths) AS total_new_deaths
-- 	,SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- JOIN covid_deaths with covid_vaccinations
SELECT *
FROM covid_deaths deaths
JOIN covid_vaccinations vaccs
	ON deaths.location = vaccs.location
	AND deaths.date = vaccs.date
ORDER BY deaths.date;

-- Looking at Total Population vs Vaccinations
SELECT 
	deaths.continent
	,deaths.location
	,deaths.date
	,deaths.population
	,vaccs.new_vaccinations
	,SUM(vaccs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
FROM covid_deaths deaths
JOIN covid_vaccinations vaccs
	ON deaths.location = vaccs.location
	AND deaths.date = vaccs.date
WHERE deaths.continent IS NOT NULL AND deaths.location = 'South Korea'
ORDER BY 1,2,3;

-- USE CTE
WITH PopvsVac AS (
SELECT 
	deaths.continent
	,deaths.location
	,deaths.date
	,deaths.population
	,vaccs.new_vaccinations
	,SUM(vaccs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
FROM covid_deaths deaths
JOIN covid_vaccinations vaccs
	ON deaths.location = vaccs.location
	AND deaths.date = vaccs.date
WHERE deaths.continent IS NOT NULL AND deaths.location = 'South Korea'
)
SELECT 
	*,
	(rolling_people_vaccinated/population) * 100
FROM PopvsVac;

-- Create View to store data for later visualizations
DROP VIEW IF EXISTS percent_pop_vacc;
CREATE VIEW percent_pop_vacc AS 
WITH PopvsVac AS (
SELECT 
	deaths.continent
	,deaths.location
	,deaths.date
	,deaths.population
	,vaccs.new_vaccinations
	,SUM(vaccs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
FROM covid_deaths deaths
JOIN covid_vaccinations vaccs
	ON deaths.location = vaccs.location
	AND deaths.date = vaccs.date
WHERE deaths.continent IS NOT NULL AND deaths.location = 'South Korea'
)
SELECT 
	*,
	(rolling_people_vaccinated/population) * 100 pop_vac_perc
FROM PopvsVac;


-- Queries for Tableau Dashboard
-- 1.
SELECT 
	SUM(new_cases) AS total_cases
	,SUM(new_deaths) AS total_deaths
	,(SUM(new_deaths)/SUM(new_cases)*100) AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- 2.
SELECT
	location
	,SUM(new_deaths) AS total_death_count
FROM covid_deaths
WHERE 
	continent IS NULL AND 
	location IN ('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania')
GROUP BY location
ORDER BY total_death_count DESC;

-- 3.
SELECT
	location
	,population
	,COALESCE(MAX(total_cases),0) AS highest_infection_count
	,COALESCE((MAX(total_cases/population)*100),0) AS percent_population_infected
FROM covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- 4.
SELECT
	location
	,population
	,date
	,COALESCE(MAX(total_cases),0) AS highest_infection_count
	,COALESCE(MAX(total_cases/population)*100,0) AS percent_population_infected
FROM covid_deaths
GROUP BY location, population, date
ORDER BY percent_population_infected DESC;