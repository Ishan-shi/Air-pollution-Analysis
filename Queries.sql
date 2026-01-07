1. Most poluuted countries (PM2.5)

SELECT 
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
GROUP BY "country label"
ORDER BY avg_pm25 DESC;

2. Cities with most unsafe air days(PM2.5)
SELECT
    city,
    "country label",
    COUNT(*) AS unsafe_readings
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
  AND value > 15
GROUP BY city, "country label"
ORDER BY unsafe_readings DESC;

3. Most Polluted locations
SELECT
    location,
    city,
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
GROUP BY location, city, "country label"
ORDER BY avg_pm25 DESC
LIMIT 10;


4. Countries with multi pollutant risk
SELECT
    "country label",
    COUNT(DISTINCT pollutant) AS pollutant_types
FROM world_air_quality_with_locations waqwl 
WHERE value > 50
GROUP BY "country label"
ORDER BY pollutant_types DESC;

5. Most consistent pollution levels over time?**
SELECT
    city,
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25,
    ROUND(max(value) - min(value), 2) AS variability
FROM world_air_quality_with_locations
WHERE pollutant = 'PM2.5'
GROUP BY city, "country label"
ORDER BY variability ASC
LIMIT 10;

6. Worst pollution globally 
SELECT
    pollutant,
    ROUND(AVG(value), 2) AS avg_level
FROM world_air_quality_with_locations waqwl 
GROUP BY pollutant
ORDER BY avg_level DESC;


7. Which locations have outdated air quality readings

SELECT
    location,
    city,
    "country label",
    MAX(lastupdated) AS last_update
FROM world_air_quality_with_locations
GROUP BY location, city, "country label"
ORDER BY last_update ASC
LIMIT 10;


8. Cities with low average but extreme spikes

SELECT
    city,
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25,
    MAX(value) AS max_pm25
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
GROUP BY city, "country label"
HAVING AVG(value) < 20
   AND MAX(value) > 100
ORDER BY max_pm25 DESC;

9. Air quality risk classification

SELECT
    city,
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25,
    CASE
        WHEN AVG(value) < 15 THEN 'SAFE'
        WHEN AVG(value) BETWEEN 15 AND 35 THEN 'MODERATE'
        WHEN AVG(value) BETWEEN 36 AND 55 THEN 'DANGEROUS'
        ELSE 'CRITICAL'
    END AS risk_level
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
GROUP BY city, "country label";

10. Global hotspot needing immediate action

SELECT
    city,
    "country label",
    ROUND(AVG(value), 2) AS avg_pm25,
    COUNT(*) FILTER (WHERE value > 35) AS critical_readings
FROM world_air_quality_with_locations waqwl 
WHERE pollutant = 'pm25'
GROUP BY city, "country label"
ORDER BY avg_pm25 DESC, critical_readings DESC
LIMIT 5;




