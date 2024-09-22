
--Data Exploration
select *
From PortfolioProject..CovidVax
Where continent is not null
order by 3,4

select Location, Date,total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Total cases vs total deaths mortality rate

select Location, Date,total_cases, total_deaths, (total_deaths/total_cases)* 100 as mortalityRrate 
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--looking at total cases vs population in India

select Location, Date, population,total_cases, (total_cases/ population)* 100 as InfectedRrate 
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

--looking for countrieswith higest infection rate in population

select Location, population,max(total_cases) as higestInfectionCount, Max((total_cases/ population))* 100 as InfectedpopPercent
from PortfolioProject..CovidDeaths
--where location like 'india'
Group by location, population
order by InfectedpopPercent desc

--looking for countries with higest death rate in population

select Location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is null
--where location like 'india'
Group by location 
order by TotalDeathCount desc


--looking for countries with higest death rate in continent

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
--where location like 'india'
Group by continent 
order by TotalDeathCount desc


--Global Death Numbers

select sum(new_cases) as totalCases, sum(cast(new_deaths as int)) as TostalDeaths, 
 sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercent 
from PortfolioProject..CovidDeaths
Where continent is not null
--group by date
order by 1,2


--Joining
 
 Select * 
 From PortfolioProject..CovidDeaths as Dth
 Join PortfolioProject..CovidVax as Vax
	on dth.date = vax.date And
	dth.location = Vax.location

--loocking at total vaxination in world

Select dth.continent, dth.location, dth.date, 
dth.population,vax.new_vaccinations 
,SUM(Cast(vax.new_vaccinations as int)) 
over (Partition by dth.location Order by dth.location,dth.date) as rollingPeopleVax

 From PortfolioProject..CovidDeaths as Dth
 Join PortfolioProject..CovidVax as Vax
	on dth.date = vax.date And
	dth.location = Vax.location
	Where dth.continent is not null 
	Order by 2,3

--Useing CTE

With PopVSVax (Continent,Location,Date,Population,new_vaccinations, rollingPeopleVax)
as
(
Select dth.continent, dth.location, dth.date, 
dth.population,vax.new_vaccinations 
,SUM(Cast(vax.new_vaccinations as int)) 
over (Partition by dth.location Order by dth.location,dth.date) as rollingPeopleVax
 From PortfolioProject..CovidDeaths as Dth
 Join PortfolioProject..CovidVax as Vax
	on dth.date = vax.date And
	dth.location = Vax.location
	Where dth.continent is not null
	--Order by 2,3
)
Select *,(rollingPeopleVax/Population)*100 
From PopvsVax

-- using Temp Table
Drop Table if exists #percentVaxPop
create Table #percentVaxPop
(
continent nvarchar(255),
location nvarchar(255),
date DateTime,
population numeric,
new_vaccinations numeric,
rollingPeopleVax numeric
)

Insert into #percentVaxPop
Select dth.continent, dth.location, dth.date, 
dth.population,vax.new_vaccinations 
,SUM(Cast(vax.new_vaccinations as int)) 
over (Partition by dth.location Order by dth.location,dth.date) as rollingPeopleVax
 From PortfolioProject..CovidDeaths as Dth
 Join PortfolioProject..CovidVax as Vax
	on dth.date = vax.date And
	dth.location = Vax.location
	Where dth.continent is not null

Select *,(rollingPeopleVax/Population)*100 as RPV
From #percentVaxPop

-- Creating View to store data for visulization later

Create View PercentagePoPVac as 
 Select dth.continent, dth.location, dth.date, 
dth.population,vax.new_vaccinations 
,SUM(Cast(vax.new_vaccinations as int)) 
over (Partition by dth.location Order by dth.location,dth.date) as rollingPeopleVax
 From PortfolioProject..CovidDeaths as Dth
 Join PortfolioProject..CovidVax as Vax
	on dth.date = vax.date And
	dth.location = Vax.location
Where dth.continent is not null

Select * From PercentagePoPVac

