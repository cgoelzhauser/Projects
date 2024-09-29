-- Cardiovascular diseases, including heart disease, are among the most common and impactful health conditions worldwide. 
-- In this project, we will explore the key risk factors in depth to identify the most prevalent causes that contribute to heart disease, as well as lifestyle choices that can help prevent it


-- Review the dataset to get familiar with the information
SELECT *
FROM heart_disease_risk;


-- How many entries are there in this dataset
SELECT COUNT(*) AS [Number of Individuals]
FROM heart_disease_risk;


-- Update the data type of the heart_disease column and then change the 0 values to No, and the 1 values to Yes to make it a little easier to read
ALTER TABLE heart_disease_risk
ALTER COLUMN heart_disease VARCHAR(10);

UPDATE heart_disease_risk
SET heart_disease = 'No'
WHERE heart_disease = '0';

UPDATE heart_disease_risk
SET heart_disease = 'Yes'
WHERE heart_disease = '1';


-- What are the different chest_pain_type values
SELECT DISTINCT chest_pain_type
FROM heart_disease_risk;


-- What are the highest cholesterol levels in the dataset and are they associated with heart disease
SELECT cholesterol, heart_disease
FROM heart_disease_risk
ORDER BY cholesterol DESC;


-- In this dataset, which ages have the highest blood sugar
SELECT age, COUNT(blood_sugar) AS high_blood_sugar_count
FROM heart_disease_risk
WHERE blood_sugar > 140
GROUP BY age
HAVING COUNT(blood_sugar) > 10
ORDER BY high_blood_sugar_count DESC;


-- Which age range has the most cases of heart disease
WITH age_ranges AS (
SELECT age,
CASE WHEN age BETWEEN 50 AND 59 THEN '50s'
	 WHEN age BETWEEN 60 AND 69 THEN '60s'
	 WHEN age BETWEEN 70 AND 79 THEN '70s'
	 ELSE '80+' END AS age_range
FROM heart_disease_risk
WHERE heart_disease = 'Yes'
)
SELECT age_range, COUNT(*) AS heart_disease_cases
FROM age_ranges
GROUP BY age_range
ORDER BY heart_disease_cases DESC;


-- What is the average age of individuals that have heart disease
SELECT AVG(age) AS [Average Age with Heart Disease]
FROM heart_disease_risk
WHERE heart_disease = 'Yes';


-- Are males or females more prone to heart disease
SELECT gender, COUNT(*) AS number_of_cases
FROM heart_disease_risk
WHERE heart_disease = 'Yes'
GROUP BY gender
ORDER BY number_of_cases DESC;


-- Of all individuals with heart disease, what percentage of individuals are current or former smokers?
WITH SMOKE AS (
SELECT COUNT(CASE WHEN smoking = 'Current' THEN 'CurrentOrFormer'
	              WHEN smoking = 'Former'  THEN 'CurrentOrFormer'
	         END) AS Smokers,
	   COUNT(CASE WHEN smoking = 'Never'   THEN 'Never'
		     END) AS NonSmokers,
	   COUNT(CASE WHEN smoking = 'Current' THEN 'Total'
	              WHEN smoking = 'Former'  THEN 'Total'
				  WHEN smoking = 'Never'   THEN 'Total'
	         END) AS Total
FROM heart_disease_risk
WHERE heart_disease = 'Yes'
)
SELECT ROUND(Smokers * 100 / Total,2) AS [Percentage of all Smokers with Heart Disease]
FROM SMOKE;


-- What is the average cholesterol among individuals who have heart disease
SELECT AVG(cholesterol) AS average_cholesterol
FROM heart_disease_risk
WHERE heart_disease = 'Yes';


--What is the average cholesterol among individuals who do NOT have heart disease
SELECT AVG(cholesterol) AS average_cholesterol
FROM heart_disease_risk
WHERE heart_disease = 'No';


--- Update the data type of the diabetes column and then change the 0 values to No, and the 1 values to Yes to make it a little easier to read
ALTER TABLE heart_disease_risk
ALTER COLUMN diabetes VARCHAR(10);

UPDATE heart_disease_risk
SET diabetes = 'No'
WHERE diabetes = '0';

UPDATE heart_disease_risk
SET diabetes = 'Yes'
WHERE diabetes = '1';


-- How many individuals that have diabetes also have heart disease
SELECT COUNT(*) AS diabetes_and_heart_disease
FROM heart_disease_risk
WHERE diabetes = 'Yes' AND heart_disease = 'Yes';


-- What are the most common types of chest pain for all individuals in the dataset
SELECT chest_pain_type, COUNT(*) AS number_of_occurances
FROM heart_disease_risk
GROUP BY chest_pain_type
ORDER BY number_of_occurances DESC;


-- What age are the top 5 oldest individuals in the dataset
SELECT TOP 5 age, gender
FROM heart_disease_risk
ORDER BY age DESC;


-- How many individuals that have high blood pressure also have heart disease
SELECT COUNT(*) AS hypertension_and_heart_disease
FROM heart_disease_risk
WHERE blood_pressure > 130 AND heart_disease = 'Yes';


-- What are the most common types of chest pain associated with heart disease
SELECT chest_pain_type, COUNT(chest_pain_type) AS number_of_instances
FROM heart_disease_risk
WHERE heart_disease = 'Yes'
GROUP by chest_pain_type
ORDER BY number_of_instances DESC;


-- How many people have heart disease that are also obese and have hypertension
SELECT COUNT(*) AS [Obesity + Hypertension and heart disease]
FROM heart_disease_risk
WHERE obesity = 'Yes' AND blood_pressure > 140 AND heart_disease = 'Yes';


-- Is there a correlation between exercise hours per week with individuals that do not have heart disease
SELECT exercise_hours, COUNT(*) AS no_heart_disease
FROM heart_disease_risk
WHERE heart_disease = 'No'
GROUP BY exercise_hours
ORDER BY no_heart_disease DESC;