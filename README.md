# SQL_code_samples

## В репозитории представлены примеры решения задач с использованием SQL. Используется диалект MS SQL и Transact SQL.

#### Задание 1.

Таблица представлена следующими полями:
1) key
2) id
3) phone
4) mail

Тестовые данные:

1;12345;89997776655;test@mail.ru,
2;54321;87778885566;two@mail.ru,
3;98765;87776664577;three@mail,
4;66678;87778885566;four@mail.ru,
5;34567;84547895566;four@mail.ru,
6;34567;89087545678;five@mail.ru

На основании заданного поля (это может быть id, phone, mail) получить все "связанные данные"

#### Задание 2.

Имеются 2 таблицы:

таблица с данными клиентов

1) client_id
2) client_name
3) birthday
4) gender

таблица договоров

1) loan_id
2) client_id
3) loan_date

Каждый клиент может обращаться в компанию несколько раз, соответственно в базе может храниться информация по нескольким договорам на одного клиента.
Договор, оформленный клиентом у нас впервые, будем называть первым договором; договор, оформленный после – вторым; далее – третьим; и так далее.
Необходимо написать SQL запрос к базе для представления его результатов в сводной таблице вида:

|     | Количество 1 договоров, оформленных в 2020 | Количество 2 договоров, оформленных в 2020 | Количество 3 договоров, оформленных в 2020 | Количество 4 договоров, оформленных в 2020 | ... |
| --- | ------------------------------------------ | ------------------------------------------ | ------------------------------------------ | ------------------------------------------ |:---:|
|Мужчины| | | | | |
|Женщины| | | | | |

Тестовые данные:

1;'bob';'20200115';'male',
2;'rocky';'20200215';'female',
3;'like';'20200215';'female',
4;'ricky';'20200215';'male'

1;1;'20200115';10000,
2;2;'20200215';20000,
3;3;'20200315';30000,
4;4;'20200415';40000,
5;1;'20200116';15000,
6;2;'20200315';35000,
7;3;'20200315';5000,
8;1;'20200115';1500,
9;2;'20200115';500,
10;1;'20200115';1500
