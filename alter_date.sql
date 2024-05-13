ALTER TABLE covid_deaths
ALTER COLUMN "date" TYPE DATE
USING "date"::DATE;

ALTER TABLE covid_vaccinations
ALTER COLUMN "date" TYPE DATE
USING "date"::DATE;