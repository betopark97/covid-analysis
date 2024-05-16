# Covid19 Analysis Project

## Dataset:  
Edouard Mathieu, Hannah Ritchie, Lucas Rodés-Guirao, Cameron Appel, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Saloni Dattani, Diana Beltekian, Esteban Ortiz-Ospina and Max Roser (2020) - "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. Retrieved from: 'https://ourworldindata.org/coronavirus' [Online Resource]  
<hr/>  

## Dashboard (Tableau):  
[Tableau Public Link](https://public.tableau.com/app/profile/roberto.parkr/viz/Covid19Analysis_17157630593080/Dashboard1)
![dashboard preview](./dashboard-preview)
<hr/>

## Description:
This project is a simple descriptive statistical analysis on Covid19. Mostly it depicts the casualties as in total infection, total death and the fatality rate of each country over the years of 2020 to 2024.  
The overall process of this project was done in the following steps:  
1. Download the full dataset of Covid19 from OurWorldInData.org as a csv file. (owid-covid-data.csv)
2. Go into excel and separate data for deaths and vaccinations.
2. Make a python script to upload the data into pgAdmin to make sql queries with PostgreSQL. (main.py)
3. Make SQL queries for exploratory data analysis. (covid_analysis.sql)
4. Extract valuable trends to display into the dashboard. (tableau1~4.csv)
5. Go into Tableau Public and make the dashboard.

## Insights:  
This was my first project on Data Analysis with SQL and Tableau and I wanted to keep it simple to learn the general concepts on how to use the technologies in hand. What I realized by doing this project is that some of the data is missing in the recent months and also that some countries may not be reporting the correct amount of infected population or any information at all. In conclusion, I should come back to this project after gaining more skills to try and make more complex queries and sophisticated analyses such as comparing the effect of vaccinations on the reduction of infections, fatality. Also, because I am from South Korea and we were required to take at least 2 to 3 vaccinations, it would be interesting to see if that had a statistically significant effect because as shown in the dashboard South Korea had the most infected population out of the G20 countries.