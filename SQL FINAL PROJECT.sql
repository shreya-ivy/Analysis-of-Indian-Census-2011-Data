create database census_2011;
use census_2011;
select * from dataset1;
select * from dataset2;
select * from `cleaned dataset2`;
alter table dataset1 change column ï»¿District District varchar (50);
alter table `cleaned dataset2` change column ï»¿District District varchar (50);
alter table dataset2 change column ï»¿District District varchar (50);

-- Which state has the highest growth rate?   
SELECT STATE, 
    MAX(GROWTH) AS Highest_Growth_Rate
   FROM Dataset1
GROUP BY STATE
ORDER BY Highest_Growth_Rate desc 
limit 5;

-- Which state has the lowest growth rate?   
SELECT STATE, 
    MAX(GROWTH) AS Lowest_Growth_Rate
   FROM Dataset1
GROUP BY STATE
ORDER BY Lowest_Growth_Rate ASC
limit 5;

-- Which district has the highest growth rate?
select District, State, Growth
from dataset1
order by Growth desc limit 10;

-- Which district has the lowest growth rate?
select District, State, Growth
from dataset1
order by Growth asc limit 10;

 -- What is the National Average Growth Rate?
 SELECT round(AVG(GROWTH),2) AS Avg_Growth_Rate
FROM Dataset1;

-- Districts with Growth Rate Higher than National Average
WITH National_Avg_Growth AS (
    SELECT round(AVG(GROWTH),2) AS Avg_Growth_Rate
    FROM Dataset1
)
SELECT d1.DISTRICT, d1.STATE, d1.GROWTH
FROM Dataset1 d1 JOIN National_Avg_Growth nag ON d1.GROWTH > nag.Avg_Growth_Rate
order by district desc;

-- Districts with Growth Rate lower than National Average
WITH National_Avg_Growth AS (
    SELECT round(AVG(GROWTH),2) AS Avg_Growth_Rate
    FROM Dataset1
)
SELECT d1.DISTRICT, d1.STATE, d1.GROWTH
FROM Dataset1 d1 JOIN National_Avg_Growth nag ON d1.GROWTH < nag.Avg_Growth_Rate
order by district desc;
    
-- Districts with Growth Rate equal to National Average 
WITH National_Avg_Growth AS (
    SELECT round(AVG(GROWTH),2) AS Avg_Growth_Rate
    FROM Dataset1
)
SELECT d1.DISTRICT, d1.STATE, d1.GROWTH
FROM Dataset1 d1 JOIN National_Avg_Growth nag ON d1.GROWTH = nag.Avg_Growth_Rate;

-- What is the sex ratio distribution by state?
SELECT STATE, round(AVG(SEX_RATIO)) AS Avg_Sex_Ratio
FROM Dataset1
GROUP BY STATE
ORDER BY Avg_Sex_Ratio DESC;

-- District wise sex ratio distribution
WITH StateAvgSexRatio AS (
    SELECT STATE, ROUND(AVG(SEX_RATIO)) AS Avg_Sex_Ratio
    FROM Dataset1
    GROUP BY STATE
)
SELECT d.DISTRICT, d.STATE, d.SEX_RATIO, s.Avg_Sex_Ratio
FROM Dataset1 d
JOIN StateAvgSexRatio s ON d.STATE = s.STATE
ORDER BY d.SEX_RATIO DESC;

-- National/ State Average Sex ratio 
SELECT round(AVG(SEX_RATIO)) AS Avg_Sex_Ratio
FROM Dataset1;

-- Districts with Sex Ratio Above State Average
WITH National_Average_Sex_Ratio AS (
    SELECT STATE,
        round(AVG(SEX_RATIO) )AS Avg_Sex_Ratio
    FROM Dataset1
    GROUP BY STATE
)
SELECT d1.DISTRICT, d1.STATE, d1.SEX_RATIO
FROM Dataset1 d1 JOIN National_Average_Sex_Ratio sr ON d1.STATE = sr.STATE
WHERE d1.SEX_RATIO > sr.Avg_Sex_Ratio
order by sex_ratio desc;

  -- Districts with Sex Ratio Below State Average
WITH National_Average_Sex_Ratio AS (
    SELECT STATE,
        round(AVG(SEX_RATIO) )AS Avg_Sex_Ratio
    FROM Dataset1
    GROUP BY STATE
)
SELECT d1.DISTRICT, d1.STATE, d1.SEX_RATIO
FROM Dataset1 d1 JOIN National_Average_Sex_Ratio sr ON d1.STATE = sr.STATE
WHERE d1.SEX_RATIO < sr.Avg_Sex_Ratio
order by sex_ratio desc;

-- What is the total population and average literacy rate for each state?
SELECT d1.STATE, 
    SUM(d2.POPULATION) AS Total_Population, 
    round(AVG(d1.LITERACY)) AS Avg_Literacy_Rate
FROM Dataset1 d1 JOIN dataset2 d2 ON d1.DISTRICT = d2.DISTRICT AND d1.STATE = d2.STATE
GROUP BY d1.STATE
ORDER BY avg_literacy_rate deSC;

-- Calculate the National literacy rate
WITH LiteratePopulation AS (
    SELECT 
        d2.STATE, 
        d2.POPULATION, 
        (d2.POPULATION * d1.LITERACY / 100.0) AS LITERATE_POPULATION
    FROM dataset2 d2 JOIN dataset1 d1 ON d2.STATE = d1.STATE
)
SELECT round(( SUM(LITERATE_POPULATION) / SUM(POPULATION) * 100 ),2)AS NATIONAL_LITERACY_RATE
FROM LiteratePopulation;

-- Districts in Different Ranges of Literacy Rates
SELECT 
    CASE 
        WHEN LITERACY BETWEEN 40 AND 50 THEN 'Poor'
        WHEN LITERACY BETWEEN 50 AND 60 THEN 'Average'
        WHEN LITERACY BETWEEN 60 AND 70 THEN 'Moderate'
        WHEN LITERACY BETWEEN 70 AND 80 THEN 'High'
        WHEN LITERACY BETWEEN 80 AND 90 THEN 'Very high'
        ELSE 'Outstanding'
    END AS Literacy_Range, COUNT(*) AS District_Count 
FROM Dataset1
GROUP BY 
    CASE 
        WHEN LITERACY BETWEEN 40 AND 50 THEN 'Poor'
        WHEN LITERACY BETWEEN 50 AND 60 THEN 'Average'
        WHEN LITERACY BETWEEN 60 AND 70 THEN 'Moderate'
        WHEN LITERACY BETWEEN 70 AND 80 THEN 'High'
        WHEN LITERACY BETWEEN 80 AND 90 THEN 'Very high'
        ELSE 'Outstanding'
       END
    order by literacy_range ;
    
    -- Trend Analysis of Growth Rate vs Literacy Rate per State
SELECT 
    STATE, 
    round(AVG(GROWTH)) AS AVERAGE_GROWTH, 
    round(AVG(LITERACY)) AS AVERAGE_LITERACY
FROM Dataset1
GROUP BY STATE
ORDER BY STATE;

-- Total population of the country
SELECT 
    SUM(POPULATION) AS Total_Population,
    SUM(AREA_KM2) AS Total_Area,
    ROUND(SUM(POPULATION) / SUM(AREA_KM2)) AS Population_Density
FROM dataset2;

-- State wise population density
SELECT 
    STATE,
    SUM(POPULATION) AS Total_Population,
    SUM(AREA_KM2) AS Total_Area,
    ROUND(SUM(POPULATION) / SUM(AREA_KM2)) AS Population_Density
FROM dataset2
GROUP BY STATE
ORDER BY Population_Density DESC;

-- Population Density per District
SELECT 
    DISTRICT,
    STATE,
    POPULATION,
    AREA_KM2,
    round((POPULATION / AREA_KM2)) AS Population_Density
FROM dataset2
ORDER BY Population_Density DESC;