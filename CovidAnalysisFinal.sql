select * from [dbo].[CovidDeaths]
where continent is not null

select location,date,total_cases,new_cases,total_deaths,population from [dbo].[CovidDeaths]
where continent is not null
order by 1,2

--Total cases vs Total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [dbo].[CovidDeaths]
where location='India'
and continent is not null
order by 1,2


--Total cases vs Ppulation
select location,date,total_cases,population,(total_cases/population)*100 as PopulationPercentage
from [dbo].[CovidDeaths]
where location='United States' and continent is not null
order by 1,2

--Highest infection rate country wise

select location,population,MAX(total_cases) as HighestCases,MAX(total_cases/population)*100 
as PopulationPercentageInfected
from [dbo].[CovidDeaths]
where continent is not null
Group by population,location
order by PopulationPercentageInfected desc

--Countries with highest deaths

select location,MAX(cast(total_deaths as int)) as HighestDeaths
from [dbo].[CovidDeaths]
where continent is not null
Group by location
order by HighestDeaths desc


--Continent with highest deaths

select location,MAX(cast(total_deaths as int)) as HighestDeaths
from [dbo].[CovidDeaths]
where continent is null
Group by location
order by HighestDeaths desc

--Continent with highest deaths per population
select continent ,MAX(cast(total_deaths as int)) as HighestDeaths
from [dbo].[CovidDeaths]
where continent is null
Group by continent
order by HighestDeaths desc

--Daily global numbers
select date,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as CumulativeDeathPercent
from [dbo].[CovidDeaths]
where continent is not null
group by date
order by date desc


--Joining vaccine and deaths table

select * from [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccine] vac
on dea.location = vac.location
and dea.date=vac.date


--Total population who got vaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.date,dea.location) as CumulativeSum
from [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccine] vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null




