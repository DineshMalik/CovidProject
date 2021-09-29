select * from CovidProject..coviddeath
order by 3,4

SELECT *
from CovidProject..covidvaccination1 
order by 3,4


select location,date, total_cases,new_cases,total_deaths,population
from CovidProject..coviddeath 
order by 1,2

-- looking at the Total cases vs Total deaths

select location,date, total_cases,total_deaths
from CovidProject..coviddeath 
order by 1,2

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from CovidProject..coviddeath 
order by 1,2

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from CovidProject..coviddeath
where location like '%india%'
order by 1,2

select location,date, total_cases,population,(total_cases/population)*100 as covid_percentage
from CovidProject..coviddeath
where location like '%india%'
order by 1,2

-- Countries with highest infection rate compared to population 

 select location, max(total_cases) as maximumcount,population,(max(total_cases/population))*100 as infection_rate
from CovidProject..coviddeath
group by location,population
order by infection_rate desc

-- Global Numbers

select sum(new_cases) as total_cases, sum (cast(new_deaths as int )) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deahpercentage
from CovidProject..coviddeath 
where continent is not null
order by 1,2 


-- Total Population vs Vaccination

select d.continent ,d.location,d.date,d.population,v.new_vaccinations
from CovidProject..coviddeath d
join CovidProject..covidvaccination1 v
 on d.location=v.location
 and d.date=v.date 
where d.continent is not null
 order by 2,3


 -- use cte 

 with populationvsvaccination( continent, location,date,population,new_vaccinations,rollingpeoplevaccinationated)
 as
 (
 select d.continent, d.location,d.date,d.population,v.new_vaccinations
 ,sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,
 d.date) as rollingpeoplevaccinated
from CovidProject..coviddeath d
join CovidProject..covidvaccination1 v
 on d.location=v.location
 and d.date=v.date 
where d.continent is not null
 )
 select * 
 from populationvsvaccination


 -- Temp Table
 drop table if exists #percentpopulationvaccinated

 create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )

 insert into #percentpopulationvaccinated
 select d.continent, d.location,d.date,d.population,v.new_vaccinations
 ,sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,
 d.date) as rollingpeoplevaccinated
from CovidProject..coviddeath d
join CovidProject..covidvaccination1 v
 on d.location=v.location
 and d.date=v.date 

 select *  ,(rollingpeoplevaccinated/population)*100
 from #percentpopulationvaccinated




