select *
from portfolioproject..[CovidDeaths ]
order by 3,4

select location, date, total_cases, new_cases,total_deaths,population
from portfolioproject..[CovidDeaths ]
order by 1,2


--Looking at Total cases vrs Total Deaths
select location, date, total_cases, (total_deaths/total_cases)*100 as DeathPercemtage
from portfolioproject..[CovidDeaths ]
where location like '%States%'
order by 1,2


--Looking at Total cases vrs Population
--Shows percentage of population got Covid


select location, date, total_cases,population, (total_cases/population)*100 as PercentageRateOfContraction
from portfolioproject..[CovidDeaths ]
where location like 'Ghana'
order by 1,2


--Looking at Countries with Highest Infection Rate compared to population

select location, population,MAX(total_cases) as highestInfectionCount, max(total_cases/population)*100 as PercentageRateOfContraction
from portfolioproject..[CovidDeaths ]
GROUP BY location, population
order by PercentageRateOfContraction desc


--Showing countries with Highest Death Count Per population

select continent, MAX(total_deaths) as totalDeathCount
from portfolioproject..[CovidDeaths ]
WHERE continent is not null
GROUP BY continent
order by  TotaldeathCount desc



--GLOBBAL NUMBERS

select date, sum(new_cases),Sum(new_Deaths) --(total_deaths/total_cases)*100 as patientsPercentageRateOfDeath
from portfolioproject..[CovidDeaths ]
--where location like 'Ghana'
where continent is not null
Group by date
order by 1,2




--Looking at total population vs vacinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject..[CovidDeaths ] dea
join portfolioproject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject..[CovidDeaths ] dea
join portfolioproject..[Covidvaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE

WITH PopvsVac (Continent, Location, Date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject..[CovidDeaths ]  dea
join portfolioproject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as PercentageRateOfVaccination
from PopvsVac



--TEMPT TABLE


drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject..[CovidDeaths ] dea
join portfolioproject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 

select *, (RollingPeopleVaccinated/population)*100 as percentagePopulationVaccinated
from #PercentPopulationVaccinated


--creatig view to store data for later visualisations
 

 create view percentPopulationVacccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as percentagePopulationVaccinated
from portfolioproject..[CovidDeaths ] dea
join portfolioproject..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
  
SELECT *
from percentPopulationVacccinated














