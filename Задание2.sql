USE test;

IF OBJECT_ID(N'dbo.loans_table', N'U') IS NOT NULL
	DROP TABLE dbo.loans_table;

IF OBJECT_ID(N'dbo.loans_table', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.loans_table (
		[loan_id] INT
		,[client_id] INT
		,[loan_date] DATE
		,[loan_amount] FLOAT
		);
END;

IF OBJECT_ID(N'dbo.clients_table', N'U') IS NOT NULL
	DROP TABLE dbo.clients_table;

IF OBJECT_ID(N'dbo.clients_table', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.clients_table (
		[client_id] INT
		,[client_name] NVARCHAR(20)
		,[birthday] DATE
		,[gender] NVARCHAR(20)
		);
END;

INSERT INTO clients_table
VALUES (
	1
	,'bob'
	,'20200115'
	,'male'
	)
	,(
	2
	,'rocky'
	,'20200215'
	,'female'
	)
	,(
	3
	,'like'
	,'20200215'
	,'female'
	)
	,(
	4
	,'ricky'
	,'20200215'
	,'male'
	);

INSERT INTO loans_table
VALUES (
	1
	,1
	,'20200115'
	,10000
	)
	,(
	2
	,2
	,'20200215'
	,20000
	)
	,(
	3
	,3
	,'20200315'
	,30000
	)
	,(
	4
	,4
	,'20200415'
	,40000
	)
	,(
	5
	,1
	,'20200116'
	,15000
	)
	,(
	6
	,2
	,'20200315'
	,35000
	)
	,(
	7
	,3
	,'20200315'
	,5000
	)
	,(
	8
	,1
	,'20200115'
	,1500
	)
	,(
	9
	,2
	,'20200115'
	,500
	)
	,(
	10
	,1
	,'20200115'
	,1500
	);




DECLARE @agreement_count INT
	,@counter INT
	,@cols1 NVARCHAR(MAX)
	,@cols2 NVARCHAR(MAX)
	,@cols3 NVARCHAR(MAX)
	,@qry NVARCHAR(MAX);

SELECT @agreement_count = MAX(cnt)
FROM (
	SELECT COUNT(client_id) AS cnt
	FROM loans_table
	GROUP BY client_id
	) AS res;

SET @counter = 1

WHILE @counter < @agreement_count + 1
BEGIN
	IF @counter = 1
	BEGIN
		SET @cols1 = ', SUM(c' + CAST(@counter AS NVARCHAR(MAX)) + ') AS ''Количество ' + CAST(@counter AS NVARCHAR(MAX)) + ' договоров, оформленных в 2020'' '
		SET @cols2 = ', c' + CAST(@counter AS NVARCHAR(MAX)) + ' = CASE WHEN loan' + CAST(@counter AS NVARCHAR(MAX)) + ' = 1 THEN 1 ELSE 0 END'
		SET @cols3 = ', ROW_NUMBER() OVER (PARTITION BY t1.client_id ORDER BY t1.client_id) AS loan' + CAST(@counter AS NVARCHAR(MAX))
	END
	ELSE
	BEGIN
		SET @cols1 = @cols1 + ', SUM(c' + CAST(@counter AS NVARCHAR(MAX)) + ') AS ''Количество ' + CAST(@counter AS NVARCHAR(MAX)) + ' договоров, оформленных в 2020'' '
		SET @cols2 = @cols2 + ', c' + CAST(@counter AS NVARCHAR(MAX)) + ' = CASE WHEN loan' + CAST(@counter AS NVARCHAR(MAX)) + ' = 1 THEN 1 ELSE 0 END'
		SET @cols3 = @cols3 + ', ROW_NUMBER() OVER (PARTITION BY t1.client_id ORDER BY t1.client_id) - ' + CAST(@counter - 1 AS NVARCHAR(MAX)) + ' AS loan' + CAST(@counter AS NVARCHAR(MAX))
	END

	SET @counter = @counter + 1
END;

SET @qry = 'SELECT gender' + @cols1 + ' FROM (SELECT gender' + @cols2 + ' FROM (SELECT t1.gender' + @cols3 + ' FROM clients_table AS t1 
JOIN loans_table AS t2 
ON t1.client_id = t2.client_id 
WHERE DATEPART(YEAR, t2.loan_date) = 2020) AS t0) AS res
GROUP BY gender;'

EXECUTE (@qry)

