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
  FROM [Salary_trends].[dbo].[salaries]

  -- Ratio of remote jobs
  SELECT
	ROUND(
		COUNT(*)/
		CAST((SELECT COUNT(*) FROM dbo.salaries) AS FLOAT)
		, 2) * 100
		AS "remote_ratio%"
  FROM dbo.salaries
  WHERE remote_ratio = 100
	OR remote_ratio = 50;