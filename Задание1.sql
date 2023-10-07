USE test;

IF OBJECT_ID(N'dbo.t1', N'U') IS NOT NULL
	DROP TABLE dbo.t1;

IF OBJECT_ID(N'dbo.t1', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.t1 (
		[key] INT
		,[id] INT
		,[phone] VARCHAR(11)
		,[mail] VARCHAR(50)
		);
END;

INSERT INTO dbo.t1
VALUES (
	1
	,12345
	,'89997776655'
	,'test@mail.ru'
	)
	,(
	2
	,54321
	,'87778885566'
	,'two@mail.ru'
	)
	,(
	3
	,98765
	,'87776664577'
	,'three@mail'
	)
	,(
	4
	,66678
	,'87778885566'
	,'four@mail.ru'
	)
	,(
	5
	,34567
	,'84547895566'
	,'four@mail.ru'
	)
	,(
	6
	,34567
	,'89087545678'
	,'five@mail.ru'
	);




DECLARE @temp TABLE (
	[key] INT
	,[id] INT
	,[phone] VARCHAR(11)
	,[mail] VARCHAR(50)
	);

INSERT INTO @temp (
	[key]
	,[id]
	,[phone]
	,[mail]
	)
SELECT *
FROM t1
WHERE phone = '87778885566';

DECLARE @row_number_prev INT

SET @row_number_prev = 0;

DECLARE @row_number INT

SET @row_number = (
		SELECT COUNT(*)
		FROM @temp
		);

WHILE @row_number_prev <> @row_number
BEGIN
	INSERT INTO @temp (
		[key]
		,[id]
		,[phone]
		,[mail]
		)
	SELECT *
	FROM (
		SELECT t1.[key]
			,t1.id
			,t1.phone
			,t1.mail
		FROM t1
		JOIN @temp AS t2 ON t1.id = t2.id
			OR t1.phone = t2.phone
			OR t1.mail = t2.mail
		) AS t0
	GROUP BY t0.[key]
		,t0.id
		,t0.phone
		,t0.mail
	HAVING COUNT(t0.[key]) = 1;

	SET @row_number_prev = @row_number
	SET @row_number = (
			SELECT COUNT(*)
			FROM @temp
			)
END;

SELECT *
FROM @temp