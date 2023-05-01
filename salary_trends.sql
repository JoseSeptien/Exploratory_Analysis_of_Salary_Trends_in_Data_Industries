/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [work_year]
      ,[experience_level]
      ,[employment_type]
      ,[job_title]
      ,[salary]
      ,[salary_currency]
      ,[salary_in_usd]
      ,[employee_residence]
      ,[remote_ratio]
      ,[company_location]
      ,[company_size]
  FROM [Salary_trends].[dbo].[salaries];


-- Number of employees by job title
SELECT 
	job_title,
	COUNT(*) AS cnt
FROM salary_trends.dbo.salaries
GROUP BY job_title
ORDER BY cnt DESC;


-- Average salary by job title and experience level over the years
SELECT
	job_title,
	work_year AS year,
	AVG(CAST(salary AS int)) AS avg_salary,
	experience_level
FROM salary_trends.dbo.salaries
GROUP BY job_title, experience_level, work_year
ORDER BY avg_salary DESC;


-- Percentage of jobs by employment type
SELECT 
	job_title,
	ROUND(COUNT(*)/ 
	CAST((SELECT COUNT(*) FROM salary_trends.dbo.salaries) AS FLOAT), 4) * 100 AS "number_of_jobs(%)"
FROM salary_trends.dbo.salaries
GROUP BY job_title
ORDER BY "number_of_jobs(%)" DESC;


-- Average salary by company size and remote work ratio
SELECT 
	company_size,
	remote_ratio,
	AVG(CAST(salary AS int)) AS avg_salary
FROM salary_trends.dbo.salaries
GROUP BY company_size, remote_ratio
ORDER BY company_size, avg_salary DESC;


-- Top 10 highest paid jobs
SELECT TOP 10
	job_title,
	ROUND(AVG(CAST(salary AS FLOAT)), 0) AS avg_salary
FROM salary_trends.dbo.salaries
GROUP BY job_title
ORDER BY avg_salary DESC;


-- Distribution of salaries by country
SELECT
	employee_residence,
	ROUND(AVG(CAST(salary AS FLOAT)), 0) AS avg_salary
FROM salary_trends.dbo.salaries
GROUP BY employee_residence
ORDER BY avg_salary DESC;


-- Ratio of remote jobs
 SELECT
	ROUND(
		COUNT(*)/
		CAST((SELECT COUNT(*) FROM salary_trends.dbo.salaries) AS FLOAT), 2) * 100
		AS "remote_ratio%"
FROM salary_trends.dbo.salaries
WHERE remote_ratio = 100
	OR remote_ratio = 50;


-- Salary growth by job title
SELECT
	job_title,
	ROUND((CAST(salary AS INT) - LAG(CAST(salary AS INT), 1) OVER(ORDER BY work_year ASC)) /
	CAST(LAG(CAST(salary AS INT), 1) OVER(ORDER BY work_year ASC) AS FLOAT) * 100, 0) AS "salary_growth(%)"
FROM salary_trends.dbo.salaries
GROUP BY job_title, work_year, salary 
ORDER BY "salary_growth(%)" DESC;


-- Ratio of employees who received a promotion
SELECT
	ROUND(COUNT(*)/
	CAST((SELECT COUNT(*) FROM salary_trends.dbo.salaries) AS FLOAT), 2) * 100 AS "promotion_ratio(%)"
FROM salary_trends.dbo.salaries
WHERE experience_level NOT LIKE 'EN'
	AND salary > 
	(SELECT AVG(CAST(salary AS FLOAT))
	 FROM salary_trends.dbo.salaries
	 WHERE experience_level = 'EN'
	 );

-- Average salary in USD for Data Scientists who work fully remotely and have at least 5 years of experience, for the year 2022
SELECT
	AVG(CAST(salary AS INT)) AS avg_salary
FROM salary_trends.dbo.salaries
WHERE job_title = 'Data Scientist'
	AND remote_ratio = 100
	AND work_year = 2022
	AND experience_level = 'MI';

